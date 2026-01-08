// app/api/founder/message/route.ts
import { cookies } from "next/headers";
import { NextResponse } from "next/server";
import { createRouteHandlerClient } from "@supabase/auth-helpers-nextjs";

export async function POST(req: Request) {
  const supabase = createRouteHandlerClient({ cookies });

  const { data: userRes } = await supabase.auth.getUser();
  const user = userRes.user;
  if (!user) return NextResponse.json({ error: "Not authenticated" }, { status: 401 });

  const body = await req.json();
  const content = String(body.content ?? "");
  let threadId = body.threadId as string | undefined;

  // create thread if missing
  if (!threadId) {
    const { data: thread, error: threadErr } = await supabase
      .schema("founder")
      .from("threads")
      .insert({ user_id: user.id, title: "Untitled", status: "active", tags: [], pinned: false })
      .select("id")
      .single();

    if (threadErr) return NextResponse.json({ error: threadErr.message }, { status: 400 });
    threadId = thread.id;
  }

  const { data: msg, error: msgErr } = await supabase
    .schema("founder")
    .from("messages")
    .insert({ thread_id: threadId, user_id: user.id, role: "user", content, meta: {} })
    .select("id, thread_id, created_at")
    .single();

  if (msgErr) return NextResponse.json({ error: msgErr.message }, { status: 400 });

  return NextResponse.json({ ok: true, message: msg });
}

