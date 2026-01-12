import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export const runtime = "nodejs";
export const dynamic = "force-dynamic";

function env(name: string) {
  const v = process.env[name];
  if (!v) throw new Error(`Missing env: ${name}`);
  return v;
}

function requireBearer(req: Request) {
  const expected = process.env.FOUNDER_API_TOKEN || "";
  if (!expected) {
    return NextResponse.json({ ok: false, error: { message: "Unauthorized" } }, { status: 401 });
  }
  const auth = req.headers.get("authorization") || "";
  const token = auth.startsWith("Bearer ") ? auth.slice(7) : "";
  if (!token || token !== expected) {
    return NextResponse.json({ ok: false, error: { message: "Unauthorized" } }, { status: 401 });
  }
  return null;
}

export async function GET(req: Request) {
  const unauthorized = requireBearer(req);
  if (unauthorized) return unauthorized;

  const url = new URL(req.url);
  const tenant_id = url.searchParams.get("tenant_id");

  if (!tenant_id) {
    return NextResponse.json(
      { ok: false, error: { message: "Missing required query param: tenant_id" } },
      { status: 400 }
    );
  }
  console.log("SRK_LEN", (process.env.SUPABASE_SERVICE_ROLE_KEY || "").length);

  const supabase = createClient(
    env("NEXT_PUBLIC_SUPABASE_URL"),
    env("SUPABASE_SERVICE_ROLE_KEY")
  );

  const { data, error } = await supabase
    .from("proposals")
    .select("id,tenant_id,proposal_type,status,risk,created_at,updated_at,payload")
    .eq("tenant_id", tenant_id)
    .order("created_at", { ascending: false })
    .limit(25);

  if (error) {
    return NextResponse.json(
      { ok: false, error: { message: error.message, code: error.code } },
      { status: 500 }
    );
  }

  return NextResponse.json({ ok: true, count: data?.length ?? 0, data });
}
