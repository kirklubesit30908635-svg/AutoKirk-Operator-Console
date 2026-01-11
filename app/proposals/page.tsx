export const dynamic = "force-dynamic";

async function getProposals() {
  // Prefer explicit site URL in production; fall back to relative for safety.
  const base =
    process.env.NEXT_PUBLIC_SITE_URL ||
    (process.env.VERCEL_URL
      ? process.env.VERCEL_URL.startsWith("http")
        ? process.env.VERCEL_URL
        : `https://${process.env.VERCEL_URL}`
      : "");

  const url = base ? `${base}/api/proposals` : "/api/proposals";

  const res = await fetch(url, { cache: "no-store" });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`GET /api/proposals failed: ${res.status} ${text}`);
  }

  return res.json();
}

export default async function ProposalsPage() {
  const data = await getProposals();

  return (
    <main style={{ padding: 24, fontFamily: "ui-sans-serif, system-ui" }}>
      <h1 style={{ fontSize: 20, fontWeight: 700 }}>Proposals</h1>
      <p style={{ marginTop: 8, opacity: 0.8 }}>
        Live read via <code>/api/proposals</code>
      </p>

      <pre
        style={{
          marginTop: 16,
          padding: 16,
          background: "#0b0b0b",
          color: "#eaeaea",
          borderRadius: 12,
          overflowX: "auto",
          fontSize: 12,
          lineHeight: 1.4,
        }}
      >
        {JSON.stringify(data, null, 2)}
      </pre>
    </main>
  );
}
