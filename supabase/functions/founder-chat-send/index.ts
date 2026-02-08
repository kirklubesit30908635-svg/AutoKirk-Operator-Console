import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

type SendRequest = {
  thread_id?: string | null;
  title?: string | null;
  input: string;
  meta?: Record<string, unknown> | null;
};

function json(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "authorization, content-type",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
    },
  });
}

function corsPreflight() {
  return new Response(null, {
    status: 204,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Headers": "authorization, content-type",
      "Access-Control-Allow-Methods": "POST, OPTIONS",
    },
  });
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return corsPreflight();
  if (req.method !== "POST") return json({ error: "Use POST" }, 405);

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY");
  if (!supabaseUrl || !supabaseAnonKey) {
    return json(
      { error: "missing_env", detail: "SUPABASE_URL / SUPABASE_ANON_KEY not set" },
      500,
    );
  }

  const authHeader = req.headers.get("Authorization") ?? "";
  if (!authHeader.startsWith("Bearer ")) {
    return json({ error: "not_authenticated", detail: "Missing Bearer token" }, 401);
  }

  const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    global: { headers: { Authorization: authHeader } },
  });

  let body: SendRequest;
  try {
    body = await req.json();
  } catch {
    return json({ error: "invalid_input", detail: "Body must be JSON" }, 400);
  }

  const input = (body.input ?? "").trim();
  if (!input) return json({ error: "invalid_input", detail: "input is required" }, 400);

  const { data: userRes, error: userErr } = await supabase.auth.getUser();
  if (userErr || !userRes?.user) {
    return json({ error: "not_authenticated", detail: userErr?.message ?? "No user" }, 401);
  }
  const userId = userRes.user.id;

  // 1) Ensure thread exists (create if missing)
  let threadId = body.thread_id ?? null;

  if (!threadId) {
    const { data: createdThread, error: threadErr } = await supabase
      .schema("founder")
      .from("threads")
      .insert({
        user_id: userId,
        title: body.title ?? undefined,
      })
      .select("id")
      .single();

    if (threadErr) {
      return json(
        { error: "thread_create_failed", detail: threadErr.message, code: threadErr.code },
        403,
      );
    }

    threadId = createdThread.id;
  } else {
    const { error: threadReadErr } = await supabase
      .schema("founder")
      .from("threads")
      .select("id")
      .eq("id", threadId)
      .single();

    if (threadReadErr) {
      return json(
        { error: "thread_not_accessible", detail: threadReadErr.message, code: threadReadErr.code },
        403,
      );
    }
  }

  // 2) Insert user message
  const meta = body.meta ?? {};
  const { data: userMsg, error: msgErr } = await supabase
    .schema("founder")
    .from("messages")
    .insert({
      thread_id: threadId,
      user_id: userId,
      role: "user",
      content: input,
      meta,
    })
    .select("id, thread_id, user_id, role, content, meta, created_at")
    .single();

  if (msgErr) {
    return json(
      { error: "message_insert_failed", detail: msgErr.message, code: msgErr.code },
      403,
    );
  }

  return json({
    ok: true,
    thread_id: threadId,
    user_message: userMsg,
  });
});

