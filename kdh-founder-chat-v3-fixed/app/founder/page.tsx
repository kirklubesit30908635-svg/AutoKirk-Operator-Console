"use client";

import { useEffect, useMemo, useState } from "react";
import { createBrowserSupabaseClient } from "@/lib/supabase/browser";
import { Card, Button, TextArea } from "@/components/ui";

type Thread = { id: string; created_at: string };
type Msg = { id: string; role: "user" | "assistant" | "system"; content: string; created_at: string };

export default function FounderPage() {
  const supabase = useMemo(() => createBrowserSupabaseClient(), []);
  const [threads, setThreads] = useState<Thread[]>([]);
  const [activeThread, setActiveThread] = useState<string | null>(null);
  const [messages, setMessages] = useState<Msg[]>([]);
  const [draft, setDraft] = useState("");
  const [busy, setBusy] = useState(false);
  const [status, setStatus] = useState<string | null>(null);

  async function loadThreads() {
    const { data, error } = await supabase
      .from("mvp_threads")
      .select("id, created_at")
      .order("created_at", { ascending: false })
      .limit(50);

    if (error) {
      setStatus(error.message);
      return;
    }
    setThreads((data || []) as any);
    if (!activeThread && data && data.length) setActiveThread(data[0].id);
  }

  async function loadMessages(threadId: string) {
    const { data, error } = await supabase
      .from("mvp_messages")
      .select("id, role, content, created_at")
      .eq("thread_id", threadId)
      .order("created_at", { ascending: true })
      .limit(200);

    if (error) {
      setStatus(error.message);
      return;
    }
    setMessages((data || []) as any);
  }

  async function createThread() {
    setStatus(null);
    const { data, error } = await supabase
      .from("mvp_threads")
      .insert({})
      .select("id, created_at")
      .single();

    if (error) {
      setStatus(error.message);
      return;
    }
    await loadThreads();
    setActiveThread(data.id);
    setMessages([]);
  }

  useEffect(() => {
    loadThreads();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    if (activeThread) loadMessages(activeThread);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [activeThread]);

  async function send() {
    if (!activeThread || !draft.trim()) return;
    setBusy(true);
    setStatus(null);

    try {
      // Insert user message
      const { error: insErr } = await supabase.from("mvp_messages").insert({
        thread_id: activeThread,
        role: "user",
        content: draft.trim()
      });
      if (insErr) throw insErr;

      setDraft("");
      await loadMessages(activeThread);

      // Call server proxy
      const r = await fetch("/api/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ threadId: activeThread, userMessage: draft.trim() })
      });
      const j = await r.json();
      if (!r.ok) throw new Error(j?.error || "Chat failed.");

      if (j?.warning) setStatus(j.warning);
      await loadMessages(activeThread);
    } catch (e: any) {
      setStatus(e?.message || "Error.");
    } finally {
      setBusy(false);
    }
  }

  async function lockMessage(messageId: string) {
    if (!activeThread) return;
    setStatus(null);
    try {
      const r = await fetch("/api/lock", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ threadId: activeThread, messageId })
      });
      const j = await r.json();
      if (!r.ok) throw new Error(j?.error || "Lock failed.");
      setStatus("Locked into vault_entries.");
    } catch (e: any) {
      setStatus(e?.message || "Lock error.");
    }
  }

  async function signOut() {
    await supabase.auth.signOut();
    window.location.href = "/founder/login";
  }

  return (
    <div style={{ minHeight: "100vh", padding: 16, display: "grid", gridTemplateColumns: "320px 1fr", gap: 16 }}>
      <div style={{ display: "grid", gap: 12, alignContent: "start" }}>
        <Card>
          <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center" }}>
            <div style={{ fontWeight: 700 }}>Threads</div>
            <Button onClick={createThread}>New</Button>
          </div>
          <div style={{ marginTop: 12, display: "grid", gap: 8, maxHeight: "70vh", overflow: "auto" }}>
            {threads.map(t => {
              const active = t.id === activeThread;
              return (
                <button
                  key={t.id}
                  onClick={() => setActiveThread(t.id)}
                  style={{
                    textAlign: "left",
                    borderRadius: 12,
                    padding: 10,
                    border: active ? "1px solid #3b82f6" : "1px solid #223042",
                    background: active ? "#0b1220" : "transparent",
                    color: "#e6edf3",
                    cursor: "pointer"
                  }}
                >
                  <div style={{ fontSize: 12, opacity: 0.8 }}>Thread</div>
                  <div style={{ fontFamily: "ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas", fontSize: 12 }}>
                    {t.id.slice(0, 8)}…{t.id.slice(-6)}
                  </div>
                  <div style={{ fontSize: 12, opacity: 0.7, marginTop: 6 }}>
                    {new Date(t.created_at).toLocaleString()}
                  </div>
                </button>
              );
            })}
            {!threads.length && <div style={{ opacity: 0.7 }}>No threads yet.</div>}
          </div>
        </Card>

        <Card>
          <div style={{ display: "grid", gap: 10 }}>
            <Button variant="ghost" onClick={() => { if (activeThread) loadMessages(activeThread); }}>Refresh</Button>
            <Button variant="danger" onClick={signOut}>Sign out</Button>
            <div style={{ fontSize: 12, opacity: 0.7 }}>
              Founder access is enforced by RLS and middleware.
            </div>
          </div>
        </Card>
      </div>

      <div style={{ display: "grid", gridTemplateRows: "1fr auto", gap: 12 }}>
        <Card>
          <div style={{ display: "grid", gap: 12, maxHeight: "78vh", overflow: "auto" }}>
            {messages.map(m => (
              <div key={m.id} style={{
                border: "1px solid #223042",
                borderRadius: 16,
                padding: 12,
                background: m.role === "assistant" ? "#0c1622" : "transparent"
              }}>
                <div style={{ display: "flex", justifyContent: "space-between", gap: 12, alignItems: "center" }}>
                  <div style={{ fontWeight: 700, textTransform: "uppercase", fontSize: 12, opacity: 0.85 }}>{m.role}</div>
                  <div style={{ display: "flex", gap: 8, alignItems: "center" }}>
                    <div style={{ fontSize: 12, opacity: 0.6 }}>{new Date(m.created_at).toLocaleString()}</div>
                    {m.role === "assistant" && (
                      <Button variant="ghost" onClick={() => lockMessage(m.id)}>LOCK</Button>
                    )}
                  </div>
                </div>
                <div style={{ marginTop: 10, whiteSpace: "pre-wrap", lineHeight: 1.5 }}>{m.content}</div>
              </div>
            ))}
            {!messages.length && (
              <div style={{ opacity: 0.7 }}>
                Start with: <code>where are we</code>
              </div>
            )}
          </div>
        </Card>

        <Card>
          <div style={{ display: "grid", gap: 10 }}>
            <TextArea
              value={draft}
              onChange={(e) => setDraft(e.target.value)}
              placeholder="Command the war room… (e.g., where are we)"
            />
            <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", gap: 10 }}>
              <div style={{ fontSize: 12, opacity: 0.75 }}>
                {status || (busy ? "Executing…" : "Ready.")}
              </div>
              <Button onClick={send} disabled={busy || !activeThread || !draft.trim()}>
                {busy ? "Running…" : "Send"}
              </Button>
            </div>
          </div>
        </Card>
      </div>
    </div>
  );
}
