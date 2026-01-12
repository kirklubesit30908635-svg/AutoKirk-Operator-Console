"use client";

import { useState } from "react";

export default function HomePage() {
  const [email, setEmail] = useState("");
  const [status, setStatus] = useState<string | null>(null);

  return (
    <main
      style={{
        minHeight: "100vh",
        display: "grid",
        placeItems: "center",
        padding: 24,
        fontFamily: "system-ui, sans-serif",
      }}
    >
      <div style={{ width: "100%", maxWidth: 520 }}>
        <h1 style={{ fontSize: 28, margin: 0 }}>KDH Founder Chat</h1>
        <p style={{ marginTop: 8, opacity: 0.8 }}>
          Build checkpoint: no UI libraries, no aliases. Auth wiring next.
        </p>

        <div
          style={{
            marginTop: 16,
            padding: 16,
            border: "1px solid rgba(0,0,0,0.15)",
            borderRadius: 10,
          }}
        >
          <label style={{ display: "block" }}>
            <div style={{ marginBottom: 6, opacity: 0.8 }}>Email</div>
            <input
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="you@kirkdigitalholdings.com"
              style={{
                width: "100%",
                padding: "10px 12px",
                borderRadius: 8,
                border: "1px solid rgba(0,0,0,0.2)",
                outline: "none",
              }}
            />
          </label>

          <button
            type="button"
            onClick={() => setStatus("Auth wiring pending. Build-only checkpoint reached.")}
            disabled={!email}
            style={{
              marginTop: 12,
              width: "100%",
              padding: "10px 12px",
              borderRadius: 8,
              border: "1px solid rgba(0,0,0,0.2)",
              background: "transparent",
              cursor: email ? "pointer" : "not-allowed",
            }}
          >
            Continue
          </button>

          {status && <div style={{ marginTop: 12, opacity: 0.85 }}>{status}</div>}
        </div>
      </div>
    </main>
  );
}
