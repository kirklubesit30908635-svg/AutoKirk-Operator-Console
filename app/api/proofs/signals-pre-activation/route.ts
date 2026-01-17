import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export const dynamic = "force-dynamic";
export const runtime = "nodejs";

function getAdminSupabase() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRole = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!url) throw new Error("Missing NEXT_PUBLIC_SUPABASE_URL");
  if (!serviceRole) throw new Error("Missing SUPABASE_SERVICE_ROLE_KEY");

  return createClient(url, serviceRole, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
}

function assertAdminRequest(req: Request) {
  // Set this in Vercel env: OPERATOR_ADMIN_KEY = long random string
  const required = process.env.OPERATOR_ADMIN_KEY;
  if (!required) throw new Error("Missing OPERATOR_ADMIN_KEY");

  const got = req.headers.get("x-operator-admin-key");
  if (got !== required) return false;

  return true;
}

export async function GET(req: Request) {
  try {
    if (!assertAdminRequest(req)) {
      return NextResponse.json({ ok: false, error: "Unauthorized" }, { status: 401 });
    }

    const supabase = getAdminSupabase();
    const { data, error } = await supabase.rpc("signals_pre_activation_proof", {});

    if (error) {
      return NextResponse.json(
        { ok: false, error: error.message, details: error },
        { status: 500 }
      );
    }

    return NextResponse.json({ ok: true, proof: data }, { status: 200 });
  } catch (e: any) {
    return NextResponse.json(
      { ok: false, error: e?.message ?? "Unknown error" },
      { status: 500 }
    );
  }
}
