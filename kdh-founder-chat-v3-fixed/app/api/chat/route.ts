import { NextResponse } from "next/server";
import OpenAI from "openai";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { buildSystemPrompt } from "@/lib/prompts";
import { systemNudgeFor } from "@/lib/guardrails";

export const runtime = "nodejs";

type ChatReq = { threadId: string; userMessage: string };

async function assertFounder(supabase: ReturnType<typeof createSupabaseServerClient>) {
  const { data: auth } = await supabase.auth.getUser();
  const user = auth.user;
  if (!user) return { ok: false as const, status: 401, error: "Unauthorized" };

  const { data: profile, error } = await supabase.from("profiles").select("role").eq("id", user.id).single();
  if (error) return { ok: false as const, status: 403, error: "Forbidden" };
  if (profile?.role !== "founder") return { ok: false as const, status: 403, error: "Forbidden" };

  return { ok: true as const, user };
}

async function rateLimit(supabase: ReturnType<typeof createSupabaseServerClient>, maxRequests = 20, windowSeconds = 60) {
  const { data, error } = await supabase.rpc("kdh_check_rate_limit", {
    max_requests: maxRequests,
    window_seconds: windowSeconds
  });

  // If not installed yet, fail open but warn in response
  if (error) {
    return { ok: true as const, warned: true as const, warning: "Rate limit RPC missing. Install kdh_check_rate_limit in Supabase.", data: null as any };
  }
  if (!data?.ok) {
    return { ok: false as const, status: data?.status || 429, error: data?.error || "Rate limited" };
  }
  return { ok: true as const, warned: false as const };
}

async function getSummary(supabase: ReturnType<typeof createSupabaseServerClient>, threadId: string) {
  const { data } = await supabase
    .from("mvp_thread_summaries")
    .select("summary, updated_at")
    .eq("thread_id", threadId)
    .single();
  return data?.summary || "";
}

async function upsertSummary(supabase: ReturnType<typeof createSupabaseServerClient>, threadId: string, summary: string) {
  await supabase.from("mvp_thread_summaries").upsert({
    thread_id: threadId,
    summary,
    updated_at: new Date().toISOString()
  });
}

export async function POST(req: Request) {
  try {
    const body = (await req.json()) as ChatReq;
    if (!body?.threadId || !body?.userMessage) {
      return NextResponse.json({ error: "Missing threadId or userMessage" }, { status: 400 });
    }

    const supabase = createSupabaseServerClient();
    const gate = await assertFounder(supabase);
    if (!gate.ok) return NextResponse.json({ error: gate.error }, { status: gate.status });

    const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
    const model = process.env.OPENAI_MODEL || "gpt-4.1-mini";

    // Rate limit (founder default: 20/min)
    const rl = await rateLimit(supabase, 20, 60);
    if (!rl.ok) return NextResponse.json({ error: rl.error }, { status: rl.status });

    // Moderation gate
    const mod = await openai.moderations.create({
      model: "omni-moderation-latest",
      input: body.userMessage
    });

    const flagged = mod.results?.[0]?.flagged;
    if (flagged) {
      await supabase.from("mvp_messages").insert({
        thread_id: body.threadId,
        role: "system",
        content: "Input blocked by moderation policy."
      });
      return NextResponse.json({ error: "Blocked by safety policy." }, { status: 400 });
    }

    // Compact context: summary + last 20 messages (chronological)
    const summary = await getSummary(supabase, body.threadId);

    const { data: msgs, error: msgErr } = await supabase
      .from("mvp_messages")
      .select("role, content, created_at")
      .eq("thread_id", body.threadId)
      .order("created_at", { ascending: false })
      .limit(20);

    if (msgErr) return NextResponse.json({ error: msgErr.message }, { status: 400 });

    const chronological = (msgs || []).reverse();

    const completion = await openai.chat.completions.create({
      model,
      temperature: 0.2,
      messages: [
        { role: "system", content: buildSystemPrompt() },
        ...(summary ? [{ role: "system" as const, content: `Thread summary (authoritative):\n${summary}` }] : []),
        ...chronological.map(m => ({ role: m.role as any, content: m.content })),
        { role: "system", content: systemNudgeFor(body.userMessage) }
      ]
    });

    const assistant = completion.choices[0]?.message?.content?.trim() || "No output.";

    const { error: insErr } = await supabase.from("mvp_messages").insert({
      thread_id: body.threadId,
      role: "assistant",
      content: assistant
    });

    if (insErr) return NextResponse.json({ error: insErr.message }, { status: 400 });

    // Auto-update summary every ~12 messages (non-fatal if missing table)
    try {
      const { count } = await supabase
        .from("mvp_messages")
        .select("*", { count: "exact", head: true })
        .eq("thread_id", body.threadId);

      if (count && count % 12 === 0) {
        const { data: tail } = await supabase
          .from("mvp_messages")
          .select("role, content, created_at")
          .eq("thread_id", body.threadId)
          .order("created_at", { ascending: false })
          .limit(40);

        const tailChrono = (tail || []).reverse().map(m => `${m.role.toUpperCase()}: ${m.content}`).join("\n\n");

        const summarizer = await openai.chat.completions.create({
          model: "gpt-4o-mini",
          temperature: 0.1,
          messages: [
            { role: "system", content: "Update the thread summary. Keep it compact, factual, decision-oriented. Preserve canonical directives. No fluff." },
            { role: "user", content: `CURRENT SUMMARY:\n${summary || "(none)"}\n\nRECENT MESSAGES:\n${tailChrono}\n\nReturn an updated summary only.` }
          ]
        });

        const updated = summarizer.choices[0]?.message?.content?.trim();
        if (updated) await upsertSummary(supabase, body.threadId, updated);
      }
    } catch {
      // Non-fatal
    }

    return NextResponse.json({ assistant, warning: rl.warned ? rl.warning : undefined });
  } catch (e: any) {
    return NextResponse.json({ error: e?.message || "Server error" }, { status: 500 });
  }
}
