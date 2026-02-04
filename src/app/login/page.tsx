"use client";

import { useEffect, useState } from "react";
import { createClientComponentClient } from "@supabase/auth-helpers-nextjs";

export default function LoginPage() {
  const supabase = createClientComponentClient();

  const [email, setEmail] = useState("kirklubesit30908635@gmail.com");
  const [password, setPassword] = useState("");
  const [status, setStatus] = useState("");
  const [uid, setUid] = useState("");

  useEffect(() => {
    supabase.auth.getUser().then(({ data }) => {
      if (data.user) setUid(data.user.id);
    });
  }, [supabase]);

  async function signIn(e) {
    e.preventDefault();
    setStatus("Signing in...");
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) return setStatus(error.message);
    setUid(data.user?.id ?? "");
    setStatus("Signed in successfully.");
  }

  async function signOut() {
    await supabase.auth.signOut();
    setUid("");
    setStatus("Signed out.");
  }

  return (
    <main style={{ maxWidth: 520, margin: "60px auto", fontFamily: "system-ui" }}>
      <h1>Operator Console Login</h1>

      {uid ? (
        <>
          <p><b>auth.uid():</b> {uid}</p>
          <button onClick={signOut}>Sign out</button>
        </>
      ) : (
        <form onSubmit={signIn}>
          <input
            placeholder="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <br />
          <input
            type="password"
            placeholder="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <br />
          <button type="submit">Sign in</button>
        </form>
      )}

      <p>{status}</p>
    </main>
  );
}
