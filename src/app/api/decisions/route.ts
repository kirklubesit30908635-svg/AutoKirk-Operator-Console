// src/app/api/decisions/route.ts
import { createClient } from "@supabase/supabase-js";
import { NextResponse } from "next/server";

export async function POST(req: Request) {
  const { note } = await req.json();

  if (!note || typeof note !== "string") {
    return NextResponse.json({ error: "Invalid note" }, { status: 400 });
  }

  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      global: {
        headers: {
          Authorization: req.headers.get("authorization") ?? "",
        },
      },
    }
  );

  const { error } = await supabase
    .from("write_proofs")
    .insert({ note });

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 403 });
  }

  return NextResponse.json({ ok: true });
}
