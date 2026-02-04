// src/app/decisions/page.tsx
"use client";

import { useEffect, useState } from "react";
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
);

export default function DecisionsPage() {
  const [note, setNote] = useState("");
  const [writes, setWrites] = useState<any[]>([]);
  const [error, setError] = useState<string | null>(null);

  async function submit() {
    setError(null);

    const session = await supabase.auth.getSession();
    if (!session.data.session) {
      setError("Authentication required");
      return;
    }

    const res = await fetch("/api/decisions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${session.data.session.access_token}`,
      },
      body: JSON.stringify({ note }),
    });

    if (!res.ok) {
      const body = await res.json();
      setError(body.error);
      return;
    }

    setNote("");
    loadWrites();
  }

  async function loadWrites() {
    const { data } = await supabase
      .from("write_proofs")
      .select("*")
      .order("created_at", { ascending: false })
      .limit(20);

    setWrites(data ?? []);
  }

  useEffect(() => {
    loadWrites();
  }, []);

  return (
    <main style={{ padding: 24 }}>
      <h1>Decisions</h1>

      <textarea
        value={note}
        onChange={(e) => setNote(e.target.value)}
        placeholder="Record a commitment…"
        rows={4}
        style={{ width: "100%" }}
      />

      <button onClick={submit}>Commit Decision</button>

      {error && <p style={{ color: "red" }}>{error}</p>}

      <hr />

      <ul>
        {writes.map((w) => (
          <li key={w.id}>
            <strong>{new Date(w.created_at).toLocaleString()}</strong>
            <br />
            {w.note}
          </li>
        ))}
      </ul>
    </main>
  );
}
