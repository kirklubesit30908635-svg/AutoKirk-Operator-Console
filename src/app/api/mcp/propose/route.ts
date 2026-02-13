import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

function errShape(e: any) {
  if (!e) return null;
  return {
    message: e.message ?? String(e),
    code: e.code ?? null,
    details: e.details ?? null,
    hint: e.hint ?? null,
  };
}

export async function POST(req: Request) {
  const SUPABASE_URL = process.env.SUPABASE_URL;
  const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
    return NextResponse.json(
      { ok: false, error: "Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY" },
      { status: 500 }
    );
  }

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  let body: any;
  try {
    body = await req.json();
  } catch {
    return NextResponse.json({ ok: false, error: "Invalid JSON body" }, { status: 400 });
  }

  const { request_id, actor_id, intent, memo_md, proposed_patch, elimination_check } = body;

  if (!request_id || !actor_id || !intent || !memo_md || proposed_patch === undefined || !elimination_check) {
    return NextResponse.json({ ok: false, error: "Missing required fields" }, { status: 400 });
  }

  const r1 = await supabase.from("intent_log").upsert({ request_id, actor_id, intent });
  if (r1.error) return NextResponse.json({ ok: false, step: "intent_log", supabase_error: errShape(r1.error) }, { status: 500 });

  const r2 = await supabase.from("decision_memos").upsert({ request_id, actor_id, memo_md });
  if (r2.error) return NextResponse.json({ ok: false, step: "decision_memos", supabase_error: errShape(r2.error) }, { status: 500 });

  const r3 = await supabase.from("proposals").upsert({ request_id, actor_id, proposed_patch, elimination_check, status: "proposed" });
  if (r3.error) return NextResponse.json({ ok: false, step: "proposals", supabase_error: errShape(r3.error) }, { status: 500 });

  return NextResponse.json({ ok: true, request_id, executed: false });
}
