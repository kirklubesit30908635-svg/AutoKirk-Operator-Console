import { NextResponse } from "next/server";
import { createSupabaseServer } from "@/lib/supabaseServer";

type Body = {
  subjectRef: string;
  digest: string;
  act: "APPROVE" | "NULLIFY" | "SUPERSEDE";
  targetReceiptId?: string | null;
};

export async function POST(req: Request) {
  const supabase = await createSupabaseServer();

  const { data: auth } = await supabase.auth.getUser();
  if (!auth.user) {
    return NextResponse.json({ error: "Not authenticated" }, { status: 401 });
  }

  const body = (await req.json()) as Body;

  const { data, error } = await supabase
    .from("core_receipts")
    .insert({
      subject_ref: body.subjectRef,
      digest: body.digest,
      act: body.act,
      actor_user_id: auth.user.id,
      target_receipt_id: body.targetReceiptId ?? null,
    })
    .select("id, created_at")
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 403 });
  }

  return NextResponse.json({ ok: true, receipt: data });
}
