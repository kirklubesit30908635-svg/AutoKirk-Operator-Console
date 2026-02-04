"use client";

import { useState } from "react";
import { createSupabaseBrowser } from "../../lib/supabaseBrowser";

export default function LoginPage() {
  const supabase = createSupabaseBrowser();
  const [email, setEmail] = useState("");

  async function signIn() {
    await supabase.auth.signInWithOtp({ email });
    alert("Check your email for the login link.");
  }

  return (
    <main style={{ padding: 32 }}>
      <h1>Login</h1>
      <input
        placeholder="you@domain.com"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
      />
      <button onClick={signIn}>Send Magic Link</button>
    </main>
  );
}
