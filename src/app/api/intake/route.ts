import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export async function POST(req: Request) {
  try {
    const body = await req.json().catch(() => null);

    const name = String(body?.name ?? "").trim();
    const email = String(body?.email ?? "").trim().toLowerCase();
    const bottleneck = String(body?.bottleneck ?? "").trim();

    if (!email || !bottleneck) {
      return NextResponse.json({ ok: false, error: "Missing email or bottleneck." }, { status: 400 });
    }

    const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const service = process.env.SUPABASE_SERVICE_ROLE_KEY;

    if (!url || !service) {
      console.error("ENV MISSING", { hasUrl: !!url, hasService: !!service });
      return NextResponse.json(
        { ok: false, error: "Missing env vars on server. Check .env.local keys." },
        { status: 500 }
      );
    }

    const supabase = createClient(url, service, { auth: { persistSession: false } });

    const { data, error } = await supabase.from("applications").insert({
      name: name || null,
      email,
      bottleneck,
      status: "new",
    }).select().single();

    if (error) {
      console.error("SUPABASE INSERT ERROR", error);
      return NextResponse.json(
        { ok: false, error: error.message, code: (error as any).code ?? null, details: (error as any).details ?? null },
        { status: 500 }
      );
    }

    return NextResponse.json({ ok: true, row: data });
  } catch (e: any) {
    console.error("INTAKE UNHANDLED ERROR", e);
    return NextResponse.json({ ok: false, error: String(e?.message ?? e) }, { status: 500 });
  }
}
