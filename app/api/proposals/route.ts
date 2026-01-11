import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export const dynamic = "force-dynamic";

export async function GET(req: Request) {
  const url = new URL(req.url);
  const tenantId = url.searchParams.get("tenant_id");

  if (!tenantId) {
    return NextResponse.json(
      { ok: false, error: "MISSING_TENANT_ID" },
      { status: 400 }
    );
  }

  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!supabaseUrl || !serviceRoleKey) {
    return NextResponse.json(
      {
        ok: false,
        error: "MISSING_ENV",
        missing: {
          NEXT_PUBLIC_SUPABASE_URL: !supabaseUrl,
          SUPABASE_SERVICE_ROLE_KEY: !serviceRoleKey,
        },
      },
      { status: 500 }
    );
  }

  const supabase = createClient(supabaseUrl, serviceRoleKey);

  const { data, error } = await supabase
    .from("proposals")
    .select("*")
    .eq("tenant_id", tenantId)
    .order("created_at", { ascending: false })
    .limit(50);

  if (error) {
    return NextResponse.json(
      { ok: false, error: "SUPABASE_ERROR", details: error },
      { status: 500 }
    );
  }

  return NextResponse.json({
    ok: true,
    count: data?.length ?? 0,
    data,
  });
}
