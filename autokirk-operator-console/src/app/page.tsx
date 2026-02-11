export default function Home() {
  return (
    <main
      style={{
        minHeight: "100vh",
        background: "#000",
        color: "#d4af37",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "48px 20px",
        fontFamily: "system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif",
      }}
    >
      <div style={{ width: "min(980px, 100%)" }}>
        <div style={{ marginBottom: 28 }}>
          <div style={{ letterSpacing: 2, fontSize: 12, opacity: 0.85 }}>
            AUTO KIRK • OPERATOR CONSOLE
          </div>
          <h1 style={{ margin: "10px 0 0", fontSize: 44, lineHeight: 1.05 }}>
            Surface Simplicity.
            <br />
            Core Ruthlessness.
          </h1>
          <p style={{ margin: "16px 0 0", maxWidth: 720, color: "#c9b56f" }}>
            This UI does not govern. It routes you into governed execution. If it
            isn’t written here, it didn’t happen.
          </p>
        </div>

        <div
          style={{
            display: "grid",
            gridTemplateColumns: "repeat(auto-fit, minmax(220px, 1fr))",
            gap: 14,
          }}
        >
          <Card
            title="TUCKER"
            desc="Next Actions. Reassurance search. Daily check-in."
            href="/tucker"
          />
          <Card
            title="Billing Ops"
            desc="Stripe event intake → obligations → closure."
            href="/"
            disabled
          />
          <Card
            title="Login"
            desc="Supabase magic-link entry."
            href="/login"
          />
        </div>

        <div style={{ marginTop: 22, fontSize: 12, color: "#a58f45" }}>
          Tip: open <code style={codeStyle}>/tucker</code> to verify DB/RLS + views.
        </div>
      </div>
    </main>
  );
}

function Card({
  title,
  desc,
  href,
  disabled,
}: {
  title: string;
  desc: string;
  href: string;
  disabled?: boolean;
}) {
  const base: React.CSSProperties = {
    border: "1px solid rgba(212,175,55,0.22)",
    borderRadius: 14,
    padding: 18,
    background: "rgba(255,255,255,0.03)",
    boxShadow: "0 10px 30px rgba(0,0,0,0.35)",
    display: "flex",
    flexDirection: "column",
    gap: 10,
  };

  const linkStyle: React.CSSProperties = disabled
    ? {
        marginTop: 8,
        padding: "10px 12px",
        borderRadius: 10,
        border: "1px solid rgba(212,175,55,0.18)",
        color: "rgba(212,175,55,0.55)",
        textDecoration: "none",
        cursor: "not-allowed",
        userSelect: "none",
      }
    : {
        marginTop: 8,
        padding: "10px 12px",
        borderRadius: 10,
        background: "#d4af37",
        color: "#000",
        textDecoration: "none",
        fontWeight: 650,
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "space-between",
        gap: 10,
      };

  return (
    <div style={base}>
      <div style={{ fontSize: 12, opacity: 0.85, letterSpacing: 1.4 }}>
        WORKSPACE
      </div>
      <div style={{ fontSize: 22, fontWeight: 750 }}>{title}</div>
      <div style={{ color: "#c9b56f", lineHeight: 1.35 }}>{desc}</div>

      {disabled ? (
        <div style={linkStyle}>Locked</div>
      ) : (
        <a style={linkStyle} href={href}>
          Enter <span aria-hidden="true">→</span>
        </a>
      )}
    </div>
  );
}

const codeStyle: React.CSSProperties = {
  padding: "2px 6px",
  borderRadius: 8,
  background: "rgba(212,175,55,0.12)",
  border: "1px solid rgba(212,175,55,0.18)",
};
