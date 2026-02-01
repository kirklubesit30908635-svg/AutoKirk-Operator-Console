"use client";

import React from "react";

export default function Home() {
  return (
    <main style={{ minHeight: "100vh", background: "#0a0a0a", color: "#fff" }}>
      <div style={{ maxWidth: 820, margin: "0 auto", padding: "64px 24px" }}>
        <div
          style={{
            border: "1px solid #2a2a2a",
            borderRadius: 18,
            padding: 36,
            background: "rgba(0,0,0,0.65)",
          }}
        >
          <div style={{ fontSize: 12, letterSpacing: 0.6, opacity: 0.65 }}>
            Kirk Digital Holdings
          </div>

          <h1 style={{ marginTop: 14, fontSize: 30, lineHeight: 1.15 }}>
            Most people don’t need more tools.
            <br />
            They need control.
          </h1>

          <p style={{ marginTop: 16, fontSize: 14, opacity: 0.78, maxWidth: 680 }}>
            Autokirk is a governed execution system. Access is intentional. Submit your bottleneck.
            If you can’t articulate it clearly, you are not approved.
          </p>

          <div
            style={{
              marginTop: 18,
              padding: 14,
              borderRadius: 14,
              border: "1px solid #2a2a2a",
              background: "rgba(255,255,255,0.03)",
              fontSize: 12,
              opacity: 0.75,
            }}
          >
            <b>Acceptance filter:</b> “They clearly articulate a real bottleneck.”
          </div>

          <form
            style={{ marginTop: 26, display: "grid", gap: 14 }}
            onSubmit={async (e) => {
              e.preventDefault();
              const form = e.currentTarget;
              const data = new FormData(form);

              const payload = {
                name: String(data.get("name") || "").trim(),
                email: String(data.get("email") || "").trim(),
                bottleneck: String(data.get("bottleneck") || "").trim(),
              };

              const res = await fetch("/api/intake", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload),
              });

              if (res.ok) window.location.href = "/requested";
              else alert("Submission failed. Check server logs.");
            }}
          >
            <input name="name" placeholder="Name (optional)" style={inputStyle} />

            <input
              name="email"
              type="email"
              required
              placeholder="Email (required)"
              style={inputStyle}
            />

            <textarea
              name="bottleneck"
              required
              rows={6}
              placeholder="What is the primary bottleneck currently limiting execution? Be specific."
              style={inputStyle}
            />

            <button type="submit" style={buttonStyle}>
              Request Access
            </button>
          </form>

          <div style={{ marginTop: 18, fontSize: 12, opacity: 0.6 }}>
            Human-in-the-loop by design • No autonomous irreversible actions
          </div>
        </div>
      </div>
    </main>
  );
}

const inputStyle: React.CSSProperties = {
  background: "#0f0f0f",
  border: "1px solid #2a2a2a",
  borderRadius: 12,
  padding: "12px 14px",
  color: "#fff",
  fontSize: 14,
  outline: "none",
};

const buttonStyle: React.CSSProperties = {
  marginTop: 6,
  padding: "14px 18px",
  borderRadius: 14,
  border: "1px solid #b08d2a",
  background: "transparent",
  color: "#e5c15a",
  fontSize: 14,
  cursor: "pointer",
};
