import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

type Payload = {
  request_id: string;
  executed_by: string;
};

export async function POST(req: Request) {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!
  );

  let body: Payload;
  try {
    body = (await req.json()) as Payload;
  } catch {
    return NextResponse.json({ ok: false, error: "Invalid JSON body" }, { status: 400 });
  }

  const { request_id, executed_by } = body;

  if (!request_id || !executed_by) {
    return NextResponse.json(
      { ok: false, error: "Missing required fields: request_id, executed_by" },
      { status: 400 }
    );
  }

  const { data, error } = await supabase.rpc("fn_mcp_execute_state_change", {
    p_request_id: request_id,
    p_executed_by: executed_by,
  });

  if (error) {
    return NextResponse.json(
      { ok: false, error: error.message, code: (error as any).code ?? null },
      { status: 500 }
    );
  }

  return NextResponse.json(data);
}
