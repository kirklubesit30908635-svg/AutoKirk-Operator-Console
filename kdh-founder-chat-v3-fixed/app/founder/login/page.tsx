"use client";

import { useEffect, useMemo, useState } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import { createBrowserSupabaseClient } from "@/lib/supabase/browser";
import { Card, Button, Input } from "@/components/ui";

export default function LoginPage() {
  const supabase = useMemo(() => createBrowserSupabaseClient(), []);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [mode, setMode] = useState<"password" | "magic">("password");
  const [status, setStatus] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const params = useSearchParams();
  const router = useRouter();
  const nextPath = params.get("next") || "/founder";

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => {
      if (data.session) router.push(nextPath);
    });
  }, [supabase, router, nextPath]);

  async function signIn() {
    setLoading(true);
    setStatus(null);
    try {
      if (mode === "password") {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
        router.push(nextPath);
      } else {
        const { error } = await supabase.auth.signInWithOtp({
          email,
          options: { emailRedirectTo: `${window.location.origin}/founder` }
        });
        if (error) throw error;
        setStatus("Magic link sent. Check your inbox.");
      }
    } catch (e: any) {
      setStatus(e?.message || "Login failed.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div style={{ minHeight: "100vh", display: "grid", placeItems: "center", padding: 24 }}>
      <div style={{ width: "100%", maxWidth: 520, display: "grid", gap: 14 }}>
        <div style={{ display: "grid", gap: 6 }}>
          <div style={{ fontSize: 22, fontWeight: 700 }}>KDH Founder Chat</div>
          <div style={{ opacity: 0.8 }}>Founder-only access. Supabase Auth required.</div>
        </div>

        <Card>
          <div style={{ display: "grid", gap: 10 }}>
            <div style={{ display: "flex", gap: 10 }}>
              <Button variant={mode === "password" ? "primary" : "ghost"} onClick={() => setMode("password")}>Password</Button>
              <Button variant={mode === "magic" ? "primary" : "ghost"} onClick={() => setMode("magic")}>Magic Link</Button>
            </div>

            <div style={{ display: "grid", gap: 10 }}>
              <label>
                <div style={{ marginBottom: 6, opacity: 0.8 }}>Email</div>
                <Input value={email} onChange={(e) => setEmail(e.target.value)} placeholder="you@kirkdigitalholdings.com" />
              </label>

              {mode === "password" && (
                <label>
                  <div style={{ marginBottom: 6, opacity: 0.8 }}>Password</div>
                  <Input type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="••••••••" />
                </label>
              )}

              <Button onClick={signIn} disabled={loading || !email || (mode === "password" && !password)}>
                {loading ? "Signing in..." : "Sign in"}
              </Button>

              {status && <div style={{ marginTop: 6, opacity: 0.9 }}>{status}</div>}
            </div>
          </div>
        </Card>

        <div style={{ opacity: 0.7, fontSize: 13 }}>
          If you get a 403 after login, your Supabase profile is not marked as <code>founder</code>.
        </div>
      </div>
    </div>
  );
}
