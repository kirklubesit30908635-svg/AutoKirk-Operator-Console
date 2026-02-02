"use client";

import { useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";

export default function AccountPage() {
  const sp = useSearchParams();
  const checkout = sp.get("checkout");

  const [customerId, setCustomerId] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const banner = useMemo(() => {
    if (checkout === "success")
      return "Checkout complete. Subscription will activate after Stripe confirms payment.";
    if (checkout === "cancel") return "Checkout canceled.";
    return null;
  }, [checkout]);

  async function openPortal() {
    setLoading(true);
    setError(null);

    try {
      const res = await fetch("/api/stripe/portal", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ customerId }),
      });

      const data = await res.json();
      if (!res.ok) throw new Error(data?.error || "Portal failed");

      if (data?.url) window.location.href = data.url;
      else throw new Error("Missing portal URL");
    } catch (e: any) {
      setError(e?.message ?? "Portal failed");
      setLoading(false);
    }
  }

  return (
    <main style={{ padding: 24, maxWidth: 720, margin: "0 auto" }}>
      <h1 style={{ fontSize: 28, fontWeight: 700 }}>Account</h1>

      {banner ? (
        <div
          style={{
            marginTop: 14,
            padding: 12,
            border: "1px solid #ddd",
            borderRadius: 12,
            background: "#fafafa",
          }}
        >
          {banner}
        </div>
      ) : null}

      <div
        style={{
          marginTop: 18,
          padding: 16,
          border: "1px solid #ddd",
          borderRadius: 12,
        }}
      >
        <h2 style={{ fontSize: 18, fontWeight: 600 }}>Billing</h2>
        <p style={{ marginTop: 6, color: "#444" }}>
          Manage your subscription via Stripe Billing Portal.
        </p>

        <label style={{ display: "block", marginTop: 14, fontWeight: 600 }}>
          Stripe Customer ID
        </label>
        <input
          value={customerId}
          onChange={(e) => setCustomerId(e.target.value)}
          placeholder="cus_..."
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
          onClick={openPortal}
          disabled={loading || !customerId}
          style={{
            marginTop: 16,
            padding: "10px 14px",
            borderRadius: 12,
            border: "1px solid #111",
            background: loading || !customerId ? "#eee" : "#111",
            color: loading || !customerId ? "#111" : "#fff",
            cursor: loading || !customerId ? "not-allowed" : "pointer",
            fontWeight: 700,
          }}
        >
          {loading ? "Opening…" : "Manage billing"}
        </button>

        <p style={{ marginTop: 10, fontSize: 12, color: "#666" }}>
          Next step: we will automatically store and load your customerId from webhook events.
        </p>
      </div>

      <div style={{ marginTop: 18 }}>
        <a href="/pricing">← Back to Pricing</a>
      </div>
    </main>
  );
}
