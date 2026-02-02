"use client";

import { useState } from "react";

export default function PricingPage() {
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function startCheckout() {
    setLoading(true);
    setError(null);

    try {
      const res = await fetch("/api/stripe/checkout", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ customerEmail: email || null }),
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data?.error || "Checkout failed");

      if (data?.url) window.location.href = data.url;
      else throw new Error("Missing checkout URL");
    } catch (e: any) {
      setError(e?.message ?? "Checkout failed");
      setLoading(false);
    }
  }

  return (
    <main style={{ padding: 24, maxWidth: 720, margin: "0 auto" }}>
      <h1 style={{ fontSize: 28, fontWeight: 700 }}>AutoKirk Access</h1>
      <p style={{ marginTop: 8, lineHeight: 1.5 }}>
        Subscribe to activate your Operator Console access when you’re ready.
      </p>

      <div
        style={{
          marginTop: 20,
          padding: 16,
          border: "1px solid #ddd",
          borderRadius: 12,
        }}
      >
        <h2 style={{ fontSize: 18, fontWeight: 600 }}>Subscription</h2>
        <p style={{ marginTop: 6, color: "#444" }}>
          Stripe Checkout subscription (Price ID from env).
        </p>

        <label style={{ display: "block", marginTop: 14, fontWeight: 600 }}>
          Email (optional)
        </label>
        <input
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="you@domain.com"
          style={{
            width: "100%",
            marginTop: 6,
            padding: 10,
            borderRadius: 10,
            border: "1px solid #ccc",
          }}
        />

        {error ? (
          <p style={{ marginTop: 12, color: "crimson" }}>{error}</p>
        ) : null}

        <button
          onClick={startCheckout}
          disabled={loading}
          style={{
            marginTop: 16,
            padding: "10px 14px",
            borderRadius: 12,
            border: "1px solid #111",
            background: loading ? "#eee" : "#111",
            color: loading ? "#111" : "#fff",
            cursor: loading ? "not-allowed" : "pointer",
            fontWeight: 700,
          }}
        >
          {loading ? "Redirecting…" : "Subscribe with Stripe"}
        </button>

        <p style={{ marginTop: 10, fontSize: 12, color: "#666" }}>
          If you’re using local Supabase, keep NEXT_PUBLIC_APP_URL set to
          http://localhost:3000 for success/cancel redirects.
        </p>
      </div>
    </main>
  );
}
