import Image from "next/image";

function Pill({ children }: { children: React.ReactNode }) {
  return (
    <span className="inline-flex items-center rounded-full border border-[color:var(--line)] bg-black/30 px-3 py-1 text-xs text-[color:var(--muted)] shadow-[0_0_0_1px_rgba(209,178,111,0.06)]">
      {children}
    </span>
  );
}

function Button({
  children,
  href,
  variant = "primary"
}: {
  children: React.ReactNode;
  href: string;
  variant?: "primary" | "ghost";
}) {
  const base =
    "inline-flex items-center justify-center rounded-xl px-5 py-3 text-sm font-medium transition focus:outline-none focus-visible:ring-2 focus-visible:ring-[color:var(--ring)]";
  const primary =
    "bg-gradient-to-r from-[color:var(--gold3)] via-[color:var(--gold2)] to-[color:var(--gold)] text-black shadow-royal hover:brightness-110";
  const ghost =
    "border border-[color:var(--line)] bg-black/30 text-[color:var(--text)] hover:bg-black/45 shadow-edge";

  return (
    <a className={`${base} ${variant === "primary" ? primary : ghost}`} href={href}>
      {children}
    </a>
  );
}

function Card({ title, desc }: { title: string; desc: string }) {
  return (
    <div className="glow rounded-2xl border border-[color:var(--line)] bg-black/35 p-6">
      <div className="text-sm font-semibold tracking-wide text-white">{title}</div>
      <div className="mt-2 text-sm leading-relaxed text-[color:var(--muted)]">{desc}</div>
    </div>
  );
}

export default function Page() {
  return (
    <main className="min-h-screen">
      {/* Top bar */}
      <header className="mx-auto flex w-full max-w-6xl items-center justify-between px-6 py-6">
        <div className="flex items-center gap-3">
          {/* Crest as a command mark */}
          <div className="relative h-14 w-14">
            <div className="absolute inset-0 rounded-full bg-[radial-gradient(circle_at_center,rgba(209,178,111,0.25),transparent_65%)] blur-md" />
            <Image
              src="/logo.png"
              alt="Autokirk Crest"
              width={56}
              height={56}
              className="relative object-contain drop-shadow-[0_8px_30px_rgba(0,0,0,0.65)]"
              priority
            />
          </div>

          <div className="leading-tight">
            <div className="text-sm font-semibold tracking-wide">Autokirk</div>
            <div className="text-xs text-[color:var(--faint)]">Operator Console</div>
          </div>
        </div>

        <nav className="hidden items-center gap-5 text-sm text-[color:var(--muted)] md:flex">
          <a className="hover:text-white" href="#how">How it works</a>
          <a className="hover:text-white" href="#proof">Proof</a>
          <a className="hover:text-white" href="#pricing">Pricing</a>
          <a className="hover:text-white" href="#security">Security</a>
        </nav>

        <div className="flex items-center gap-3">
          <Button href="#pricing" variant="ghost">View Pricing</Button>
          <Button href="#cta">Request Access</Button>
        </div>
      </header>

      {/* Hero */}
      <section className="mx-auto w-full max-w-6xl px-6 pt-12">
        <div className="grid gap-10 md:grid-cols-2 md:items-center">
          <div className="relative">
            {/* Crest echo watermark */}
            <div className="pointer-events-none absolute -top-28 -left-28 opacity-[0.06]">
              <Image src="/logo.png" alt="" width={420} height={420} className="object-contain" />
            </div>

            <div className="flex flex-wrap gap-2">
              <Pill>Governance-first</Pill>
              <Pill>Consent-driven execution</Pill>
              <Pill>Audit proof by default</Pill>
            </div>

            <h1 className="mt-6 text-4xl font-semibold leading-tight md:text-5xl">
              The <span className="metal-gold">Operator Console</span> where every action is
              explicit, attributable, and provable.
            </h1>

            <p className="mt-5 text-base leading-relaxed text-[color:var(--muted)]">
              Operator Console turns operations into a governed workflow:
              <span className="text-white"> propose → approve → execute → proof</span>.
              No silent actions. No hidden authority. No bypass paths.
            </p>

            <div className="mt-7 flex flex-wrap gap-3">
              <Button href="#cta">Request Access</Button>
              <Button href="#how" variant="ghost">See the Flow</Button>
            </div>

            <div className="mt-8 grid grid-cols-3 gap-3">
              <div className="rounded-2xl border border-[color:var(--line)] bg-black/30 p-4 shadow-edge">
                <div className="text-xs text-[color:var(--faint)]">Loop</div>
                <div className="mt-1 text-sm font-semibold">Intent → Proof</div>
              </div>
              <div className="rounded-2xl border border-[color:var(--line)] bg-black/30 p-4 shadow-edge">
                <div className="text-xs text-[color:var(--faint)]">Default</div>
                <div className="mt-1 text-sm font-semibold">No execution without approval</div>
              </div>
              <div className="rounded-2xl border border-[color:var(--line)] bg-black/30 p-4 shadow-edge">
                <div className="text-xs text-[color:var(--faint)]">Outcome</div>
                <div className="mt-1 text-sm font-semibold">Revenue + Trust</div>
              </div>
            </div>
          </div>

          {/* Hero panel */}
          <div className="glow rounded-2xl border border-[color:var(--line)] bg-black/35 p-6">
            <div className="flex items-start justify-between gap-4">
              <div>
                <div className="text-xs text-[color:var(--faint)]">Governance Snapshot</div>
                <div className="mt-1 text-lg font-semibold">Run Ledger</div>
              </div>
              <Pill>Verifiable chain</Pill>
            </div>

            <div className="mt-6 space-y-3 text-sm">
              <div className="rounded-xl border border-[color:var(--line)] bg-black/30 p-4">
                <div className="flex items-center justify-between">
                  <span className="text-white">Proposal Created</span>
                  <span className="text-[color:var(--faint)]">PENDING</span>
                </div>
                <div className="mt-1 text-[color:var(--muted)]">
                  Action suggested, scoped, and labeled before permission exists.
                </div>
              </div>

              <div className="rounded-xl border border-[color:var(--line)] bg-black/30 p-4">
                <div className="flex items-center justify-between">
                  <span className="text-white">Explicit Approval</span>
                  <span className="text-[color:var(--faint)]">SINGLE-USE</span>
                </div>
                <div className="mt-1 text-[color:var(--muted)]">
                  Human authorization is recorded, time-bound, attributable.
                </div>
              </div>

              <div className="rounded-xl border border-[color:var(--line)] bg-black/30 p-4">
                <div className="flex items-center justify-between">
                  <span className="text-white">Governed Execution</span>
                  <span className="text-[color:var(--faint)]">AUDITED</span>
                </div>
                <div className="mt-1 text-[color:var(--muted)]">
                  Kill switch + elimination registry + validity checks enforced before change.
                </div>
              </div>

              <div className="rounded-xl border border-[color:var(--line)] bg-black/30 p-4">
                <div className="flex items-center justify-between">
                  <span className="text-white">Proof Artifact</span>
                  <span className="text-[color:var(--faint)]">VERIFIABLE</span>
                </div>
                <div className="mt-1 text-[color:var(--muted)]">
                  Before/after state logged with reversal context.
                </div>
              </div>
            </div>

            <div className="mt-6 hr-gold" />

            <div className="mt-6 flex flex-wrap items-center justify-between gap-3">
              <div className="text-xs text-[color:var(--faint)]">
                Autokirk governance remains infrastructure. Operator Console is the interface.
              </div>
              <a href="#proof" className="text-xs font-semibold text-[color:var(--gold2)] hover:brightness-110">
                View Proof Standard →
              </a>
            </div>
          </div>
        </div>
      </section>

      {/* How it works */}
      <section id="how" className="mx-auto mt-16 w-full max-w-6xl px-6">
        <div className="hr-gold mb-10" />
        <div className="flex flex-wrap items-end justify-between gap-4">
          <h2 className="text-2xl font-semibold">Governed flow, clean UI.</h2>
          <div className="text-sm text-[color:var(--muted)]">
            Every screen maps to an execution state. No mystery steps.
          </div>
        </div>

        <div className="mt-8 grid gap-4 md:grid-cols-4">
          <Card title="1) Intent" desc="Operator defines the goal. The system translates it into a bounded, reviewable proposal." />
          <Card title="2) Proposal" desc="Action is labeled, scoped, and risk-tagged. Nothing happens yet—pure preflight." />
          <Card title="3) Approval" desc="Single-use, time-bound consent. Explicit. Attributable. Logged." />
          <Card title="4) Execution + Proof" desc="Governed execution runs through hard gates and produces verifiable artifacts." />
        </div>
      </section>

      {/* Proof standard */}
      <section id="proof" className="mx-auto mt-16 w-full max-w-6xl px-6">
        <div className="hr-gold mb-10" />
        <h2 className="text-2xl font-semibold">Proof is the product.</h2>
        <p className="mt-3 max-w-3xl text-sm leading-relaxed text-[color:var(--muted)]">
          Operator Console doesn’t ask for trust. It manufactures trust by producing an audit-ready
          chain for every meaningful action.
        </p>

        <div className="mt-8 grid gap-4 md:grid-cols-3">
          <Card title="Before/After State" desc="Every applied change captures a verifiable diff and outcome markers." />
          <Card title="Replay Prevention" desc="Approvals are single-use. Attempts to reuse approvals fail with explicit reason codes." />
          <Card title="Reversibility" desc="Reversal is a first-class governed path, not a manual “oops” process." />
        </div>
      </section>

      {/* Security */}
      <section id="security" className="mx-auto mt-16 w-full max-w-6xl px-6">
        <div className="hr-gold mb-10" />
        <h2 className="text-2xl font-semibold">Security that’s visible and enforceable.</h2>
        <div className="mt-8 grid gap-4 md:grid-cols-3">
          <Card title="No Silent Authority" desc="Presentation can change. Authority cannot. No execution without explicit grant." />
          <Card title="Hard Gates Always On" desc="Kill switch + elimination registry remain active safeguards, not optional settings." />
          <Card title="Consent-Driven by Design" desc="No execution without an attributable approval event. No bypass. No admin override path." />
        </div>
      </section>

      {/* Pricing */}
      <section id="pricing" className="mx-auto mt-16 w-full max-w-6xl px-6">
        <div className="hr-gold mb-10" />
        <div className="flex flex-wrap items-end justify-between gap-4">
          <h2 className="text-2xl font-semibold">Pricing built for outcomes.</h2>
          <div className="text-sm text-[color:var(--muted)]">
            Start minimal. Earn proof. Expand capability safely.
          </div>
        </div>

        <div className="mt-8 grid gap-4 md:grid-cols-3">
          <div className="glow rounded-2xl border border-[color:var(--line)] bg-black/35 p-6">
            <div className="text-sm font-semibold">Personal Sovereign</div>
            <div className="mt-2 text-3xl font-semibold">$49<span className="text-sm font-medium text-[color:var(--muted)]">/mo</span></div>
            <ul className="mt-4 space-y-2 text-sm text-[color:var(--muted)]">
              <li>• Governed proposal → approval loop</li>
              <li>• Proof artifacts & run ledger</li>
              <li>• Minimal operator workflows</li>
            </ul>
            <div className="mt-6">
              <Button href="#cta">Start</Button>
            </div>
          </div>

          <div className="glow rounded-2xl border border-[color:var(--line)] bg-black/35 p-6">
            <div className="flex items-center justify-between gap-3">
              <div className="text-sm font-semibold">Builder Operator</div>
              <Pill>Most Popular</Pill>
            </div>
            <div className="mt-2 text-3xl font-semibold">$149<span className="text-sm font-medium text-[color:var(--muted)]">/mo</span></div>
            <ul className="mt-4 space-y-2 text-sm text-[color:var(--muted)]">
              <li>• Higher action volume</li>
              <li>• Expanded governance checks</li>
              <li>• Operator-grade workflow panels</li>
            </ul>
            <div className="mt-6">
              <Button href="#cta">Request Access</Button>
            </div>
          </div>

          <div className="glow rounded-2xl border border-[color:var(--line)] bg-black/35 p-6">
            <div className="text-sm font-semibold">Enterprise Control</div>
            <div className="mt-2 text-3xl font-semibold">Custom</div>
            <ul className="mt-4 space-y-2 text-sm text-[color:var(--muted)]">
              <li>• Team governance & roles</li>
              <li>• External log integrations</li>
              <li>• Dedicated proof reporting</li>
            </ul>
            <div className="mt-6">
              <Button href="#cta" variant="ghost">Talk to Us</Button>
            </div>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section id="cta" className="mx-auto mt-16 w-full max-w-6xl px-6 pb-20">
        <div className="hr-gold mb-10" />
        <div className="glow rounded-2xl border border-[color:var(--line)] bg-black/35 p-8 md:p-10">
          <h3 className="text-2xl font-semibold">Turn operations into a governed advantage.</h3>
          <p className="mt-3 max-w-2xl text-sm leading-relaxed text-[color:var(--muted)]">
            Operator Console is the face. Governance is the engine. Your business gets a workflow
            where outcomes are provable and mistakes have bounded blast radius.
          </p>

          <div className="mt-7 flex flex-wrap gap-3">
            <Button href="/login">Login</Button>
            <Button href="/request-access" variant="ghost">Request Access</Button>
          </div>

          <div className="mt-6 text-xs text-[color:var(--faint)]">
            This page is intentionally minimal. Trust is earned through proof artifacts, not hype.
          </div>
        </div>

        <footer className="mt-10 flex flex-wrap items-center justify-between gap-4 text-xs text-[color:var(--faint)]">
          <div>© {new Date().getFullYear()} Kirk Digital Holdings LLC — Autokirk</div>
          <div className="flex gap-4">
            <a className="hover:text-white" href="/terms">Terms</a>
            <a className="hover:text-white" href="/privacy">Privacy</a>
          </div>
        </footer>
      </section>
    </main>
  );
}
