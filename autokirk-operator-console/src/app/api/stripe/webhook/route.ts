import { NextRequest, NextResponse } from "next/server";
import Stripe from "stripe";
import { supabaseAdmin } from "@/lib/supabaseAdmin";

export const runtime = "nodejs";

export async function POST(req: NextRequest) {
  const env = {
    STRIPE_SECRET_KEY: process.env.STRIPE_SECRET_KEY ? "set" : "missing",
    STRIPE_WEBHOOK_SECRET: process.env.STRIPE_WEBHOOK_SECRET ? "set" : "missing",
    NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL ? "set" : "missing",
    SUPABASE_SERVICE_ROLE_KEY: process.env.SUPABASE_SERVICE_ROLE_KEY ? "set" : "missing",
  };

  try {
    if (!process.env.STRIPE_SECRET_KEY) {
      return NextResponse.json({ env, error: "Missing STRIPE_SECRET_KEY" }, { status: 500 });
    }
    if (!process.env.STRIPE_WEBHOOK_SECRET) {
      return NextResponse.json({ env, error: "Missing STRIPE_WEBHOOK_SECRET" }, { status: 500 });
    }

    const stripe = new Stripe(process.env.STRIPE_SECRET_KEY, { apiVersion: "2025-11-17.clover" as any });

    const sig = req.headers.get("stripe-signature");
    if (!sig) return NextResponse.json({ env, error: "Missing stripe-signature header" }, { status: 400 });

    const rawBody = await req.text();
    let event: Stripe.Event;

    try {
      event = stripe.webhooks.constructEvent(rawBody, sig, process.env.STRIPE_WEBHOOK_SECRET);
    } catch (e: any) {
      return NextResponse.json(
        { env, error: "Signature verification failed", detail: String(e?.message ?? e) },
        { status: 400 }
      );
    }

    // NOTE: insertAttempt retained for debugging/log context and future expansion,
    // but the write itself is governed by DB RPC (Soft Lock v0.9).
    const insertAttempt = require 
    // SOFT LOCK v0.9: DB is the law surface (append-only, idempotent).
    const { error: ingestErr } = await supabaseAdmin.rpc("fn_ingest_stripe_event", {
      p_event_id: event.id,
      p_event_type: event.type,
      p_payload: event,
    });

    if (ingestErr) {
      return NextResponse.json(
        { env, received: { id: event.id, type: event.type }, ingest_error: ingestErr, attempted: insertAttempt },
        { status: 500 }
      );
    }

    return NextResponse.json({ ok: true, received: { id: event.id, type: event.type } }, { status: 200 });
  } catch (err: any) {
    return NextResponse.json({ env, err: String(err?.message ?? err) }, { status: 500 });
  }
}
