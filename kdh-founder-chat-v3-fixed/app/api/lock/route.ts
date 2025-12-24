import { NextResponse } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export const runtime = "nodejs";

type LockReq = { threadId: string; messageId: string };

async function assertFounder(supabase: ReturnType<typeof createSupabaseServerClient>) {
  const { data: auth } = await supabase.auth.getUser();
  const user = auth.user;
  if (!user) return { ok: false as const, status: 401, error: "Unauthorized" };

  const { data: profile, error } = await supabase.from("profiles").select("role").eq("id", user.id).single();
  if (error) return { ok: false as const, status: 403, error: "Forbidden" };
  if (profile?.role !== "founder") return { ok: false as const, status: 403, error: "Forbidden" };

  return { ok: true as const, user };
}

export async function POST(req: Request) {
  try {
    const body = (await req.json()) as LockReq;
    if (!body?.threadId || !body?.messageId) {
      return NextResponse.json({ error: "Missing threadId or messageId" }, { status: 400 });
    }

    const supabase = createSupabaseServerClient();
    const gate = await assertFounder(supabase);
    if (!gate.ok) return NextResponse.json({ error: gate.error }, { status: gate.status });

    // Fetch the message content to lock
    const { data: msg, error: msgErr } = await supabase
      .from("mvp_messages")
      .select("id, role, content, created_at")
      .eq("id", body.messageId)
      .single();

    if (msgErr || !msg) return NextResponse.json({ error: msgErr?.message || "Message not found" }, { status: 404 });
    if (msg.role !== "assistant") return NextResponse.json({ error: "Only assistant messages can be locked." }, { status: 400 });

    // Create a vault entry (decision)
    const title = `Founder Lock ${new Date().toISOString().slice(0,10)} — ${body.threadId.slice(0,8)}`;
    const summary = "Locked assistant output from Founder Chat.";
    const content = msg.content;

    const { data: inserted, error: insErr } = await supabase
      .from("vault_entries")
      .insert({
        entry_type: "decision",
        title,
        summary,
        content,
        tags: ["founder_chat", "lock"],
        importance: 4,
        status: "active",
        is_locked: true
      })
      .select("id")
      .single();

    if (insErr) return NextResponse.json({ error: insErr.message }, { status: 400 });

    return NextResponse.json({ ok: true, vaultEntryId: inserted?.id });
  } catch (e: any) {
    return NextResponse.json({ error: e?.message || "Server error" }, { status: 500 });
  }
}
