// app/page.tsx
export default function Page() {
  return (
    <main style={{ padding: 24, fontFamily: "ui-sans-serif, system-ui" }}>
      <h1 style={{ fontSize: 20, fontWeight: 700 }}>Founder Chat</h1>
      <p style={{ marginTop: 8, opacity: 0.8 }}>
        Boot OK. UI intentionally minimal. Next step: /api/health
      </p>

      <div style={{ marginTop: 16 }}>
        <a href="/api/health" style={{ textDecoration: "underline" }}>
          Open /api/health
        </a>
      </div>
    </main>
  );
}
