import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

type Payload = {
  request_id: string;
  actor_id: string; // UUID required for attribution
  intent: string;
  memo_md: string;
  proposed_patch: unknown; // JSON
  elimination_check: string;
};

export async function POST(req: Request) {
  const SUPABASE_URL = process.env.SUPABASE_URL;
  const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
    return NextResponse.json(
      { ok: false, error: "Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in environment" },
      { status: 500 }
    );
  }

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  let body: Payload;
  try {
    body = (await req.json()) as Payload;
  } catch {
    return NextResponse.json({ ok: false, error: "Invalid JSON body" }, { status: 400 });
  }

  const { request_id, actor_id, intent, memo_md, proposed_patch, elimination_check } = body;

  if (!request_id || !actor_id || !intent || !memo_md || proposed_patch === undefined || !elimination_check) {
    return NextResponse.json(
      { ok: false, error: "Missing required fields: request_id, actor_id, intent, memo_md, proposed_patch, elimination_check" },
      { status: 400 }
    );
  }

  const { data, error } = await supabase.rpc("fn_mcp_propose", {
    p_request_id: request_id,
    p_actor_id: actor_id,
    p_intent: intent,
    p_memo_md: memo_md,
    p_proposed_patch: proposed_patch,
    p_elimination_check: elimination_check,
  });

  if (error) {
    return NextResponse.json(
      {
        ok: false,
        error: error.message,
        code: (error as any).code ?? null,
        details: (error as any).details ?? null,
        hint: (error as any).hint ?? null,
      },
      { status: 500 }
    );
  }

  return NextResponse.json(data);
}
