"use client";

import React, { useMemo, useState } from "react";

type Risk = "LOW" | "MEDIUM" | "HIGH";
type Status = "PENDING" | "APPROVED" | "REJECTED" | "EXPIRED" | "BLOCKED";

type Proposal = {
  id: string;
  createdAt: string; // ISO or readable
  title: string;
  summary: string;
  risk: Risk;
  status: Status;

  // “Proof surface” fields (static mock)
  scope: {
    target: string; // e.g., "founder_state.arm_state"
    change: string; // e.g., "DISARMED → ARMED"
    tenant: string; // e.g., "kdh"
  };

  gates: Array<{
    name: "Kill Switch" | "Elimination Registry" | "Approval Validity" | "Replay Prevention";
    state: "PASS" | "FAIL" | "N/A";
    detail: string;
  }>;

  // What the operator will write (later persisted)
  memoHint?: string;
};

function cx(...parts: Array<string | false | null | undefined>) {
  return parts.filter(Boolean).join(" ");
}

function Pill({
  children,
  tone = "muted",
}: {
  children: React.ReactNode;
  tone?: "muted" | "gold" | "green" | "red" | "orange";
}) {
  const base =
    "inline-flex items-center rounded-full border px-2.5 py-1 text-[11px] font-medium tracking-wide";
  const tones: Record<string, string> = {
    muted: "border-[color:var(--line)] bg-black/30 text-[color:var(--muted)]",
    gold: "border-[color:var(--gold3)]/40 bg-black/30 text-[color:var(--gold2)]",
    green: "border-emerald-500/30 bg-black/30 text-emerald-200",
    red: "border-rose-500/30 bg-black/30 text-rose-200",
    orange: "border-amber-500/30 bg-black/30 text-amber-200",
  };
  return <span className={cx(base, tones[tone])}>{children}</span>;
}

function Button({
  children,
  onClick,
  variant = "primary",
  disabled,
}: {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: "primary" | "ghost" | "danger";
  disabled?: boolean;
}) {
  const base =
    "inline-flex items-center justify-center rounded-xl px-4 py-2.5 text-sm font-medium transition focus:outline-none focus-visible:ring-2 focus-visible:ring-[color:var(--ring)] disabled:opacity-50 disabled:cursor-not-allowed";
  const primary =
    "bg-gradient-to-r from-[color:var(--gold3)] via-[color:var(--gold2)] to-[color:var(--gold)] text-black shadow-royal hover:brightness-110";
  const ghost =
    "border border-[color:var(--line)] bg-black/30 text-[color:var(--text)] hover:bg-black/45 shadow-edge";
  const danger =
    "border border-rose-500/40 bg-black/30 text-rose-200 hover:bg-rose-500/10 shadow-edge";

  return (
    <button
      className={cx(base, variant === "primary" ? primary : variant === "danger" ? danger : ghost)}
      onClick={onClick}
      disabled={disabled}
      type="button"
    >
      {children}
    </button>
  );
}

function SectionTitle({ title, desc }: { title: string; desc?: string }) {
  return (
    <div className="flex items-end justify-between gap-3">
      <div>
        <div className="text-lg font-semibold text-white">{title}</div>
        {desc ? <div className="mt-1 text-sm text-[color:var(--muted)]">{desc}</div> : null}
      </div>
    </div>
  );
}

function Modal({
  open,
  title,
  subtitle,
  children,
  onClose,
  footer,
}: {
  open: boolean;
  title: string;
  subtitle?: string;
  children: React.ReactNode;
  onClose: () => void;
  footer?: React.ReactNode;
}) {
  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50">
      <div
        className="absolute inset-0 bg-black/70 backdrop-blur-sm"
        onClick={onClose}
        aria-hidden
      />
      <div className="absolute inset-0 flex items-center justify-center p-4">
        <div className="glow w-full max-w-3xl rounded-2xl border border-[color:var(--line)] bg-black/60 shadow-[0_20px_80px_rgba(0,0,0,0.6)]">
          <div className="flex items-start justify-between gap-4 border-b border-[color:var(--line)] px-6 py-5">
            <div>
              <div className="text-base font-semibold text-white">{title}</div>
              {subtitle ? (
                <div className="mt-1 text-sm text-[color:var(--muted)]">{subtitle}</div>
              ) : null}
            </div>
            <button
              onClick={onClose}
              className="rounded-lg border border-[color:var(--line)] bg-black/30 px-3 py-1.5 text-xs text-[color:var(--muted)] hover:bg-black/45"
              type="button"
            >
              Close
            </button>
          </div>

          <div className="px-6 py-5">{children}</div>

          {footer ? (
            <div className="flex flex-wrap items-center justify-end gap-3 border-t border-[color:var(--line)] px-6 py-4">
              {footer}
            </div>
          ) : null}
        </div>
      </div>
    </div>
  );
}

function statusTone(status: Status): "muted" | "green" | "red" | "orange" | "gold" {
  if (status === "APPROVED") return "green";
  if (status === "REJECTED") return "red";
  if (status === "EXPIRED") return "orange";
  if (status === "BLOCKED") return "orange";
  return "gold";
}

function riskTone(risk: Risk): "muted" | "green" | "red" | "orange" {
  if (risk === "LOW") return "green";
  if (risk === "HIGH") return "red";
  return "orange";
}

export default function ProposalInboxPage() {
  const [query, setQuery] = useState("");
  const [statusFilter, setStatusFilter] = useState<Status | "ALL">("PENDING");
  const [riskFilter, setRiskFilter] = useState<Risk | "ALL">("ALL");

  const [selected, setSelected] = useState<Proposal | null>(null);
  const [decisionOpen, setDecisionOpen] = useState(false);
  const [decisionType, setDecisionType] = useState<"APPROVE" | "REJECT">("APPROVE");

  // Operator inputs (static now; later persisted)
  const [operatorMemo, setOperatorMemo] = useState("");
  const [ackChecked, setAckChecked] = useState(false);

  const proposals: Proposal[] = useMemo(
    () => [
      {
        id: "P-00094",
        createdAt: "2026-01-03 21:14",
        title: "Change founder_state.arm_state",
        summary: "Set state.arm_state to DISARMED via governed RPC path with proof artifacts.",
        risk: "MEDIUM",
        status: "PENDING",
        scope: { target: "founder_state.arm_state", change: "ARMED → DISARMED", tenant: "kdh" },
        gates: [
          { name: "Kill Switch", state: "PASS", detail: "Kill switch enabled and checked." },
          {
            name: "Elimination Registry",
            state: "PASS",
            detail: "Target marked NON_ACTIONABLE; execution path allowed.",
          },
          { name: "Approval Validity", state: "N/A", detail: "No approval yet. Await operator decision." },
          { name: "Replay Prevention", state: "N/A", detail: "Applies only after approval token exists." },
        ],
        memoHint: "Why is this change required now? What evidence justifies it?",
      },
      {
        id: "P-00112",
        createdAt: "2026-01-06 19:02",
        title: "Rotate public API key reference",
        summary: "Update env var usage to SUPABASE_ANON_KEY in client-only surface; no secret exposure.",
        risk: "LOW",
        status: "PENDING",
        scope: { target: "env/client", change: "Key ref normalized", tenant: "kdh" },
        gates: [
          { name: "Kill Switch", state: "PASS", detail: "Kill switch checked." },
          { name: "Elimination Registry", state: "PASS", detail: "No eliminated objects referenced." },
          { name: "Approval Validity", state: "N/A", detail: "No approval yet." },
          { name: "Replay Prevention", state: "N/A", detail: "N/A until approval is minted." },
        ],
      },
      {
        id: "P-00105",
        createdAt: "2026-01-04 12:31",
        title: "Attempt execution with expired approval",
        summary: "Negative test: approval expired → expect denial, no side effects.",
        risk: "LOW",
        status: "REJECTED",
        scope: { target: "public.execute_approved_founder_state_change", change: "DENIED", tenant: "kdh" },
        gates: [
          { name: "Kill Switch", state: "PASS", detail: "Kill switch checked." },
          { name: "Elimination Registry", state: "PASS", detail: "Registry gate passed." },
          {
            name: "Approval Validity",
            state: "FAIL",
            detail: "Expired approval → denied; no state change.",
          },
          { name: "Replay Prevention", state: "PASS", detail: "No consumption occurred." },
        ],
      },
    ],
    []
  );

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    return proposals
      .filter((p) => (statusFilter === "ALL" ? true : p.status === statusFilter))
      .filter((p) => (riskFilter === "ALL" ? true : p.risk === riskFilter))
      .filter((p) => {
        if (!q) return true;
        return (
          p.id.toLowerCase().includes(q) ||
          p.title.toLowerCase().includes(q) ||
          p.summary.toLowerCase().includes(q) ||
          p.scope.target.toLowerCase().includes(q)
        );
      })
      .sort((a, b) => (a.createdAt < b.createdAt ? 1 : -1));
  }, [proposals, query, statusFilter, riskFilter]);

  function openReview(p: Proposal) {
    setSelected(p);
    setOperatorMemo("");
    setAckChecked(false);
  }

  function openDecision(type: "APPROVE" | "REJECT") {
    setDecisionType(type);
    setDecisionOpen(true);
  }

  function closeAll() {
    setDecisionOpen(false);
    setSelected(null);
    setOperatorMemo("");
    setAckChecked(false);
  }

  // Static state transition: updates only in UI memory
  const [localOverride, setLocalOverride] = useState<Record<string, Status>>({});
  const effectiveStatus = (p: Proposal): Status => localOverride[p.id] ?? p.status;

  function confirmDecision() {
    if (!selected) return;
    const nextStatus: Status = decisionType === "APPROVE" ? "APPROVED" : "REJECTED";
    setLocalOverride((m) => ({ ...m, [selected.id]: nextStatus }));
    setDecisionOpen(false);
  }

  const selectedStatus = selected ? effectiveStatus(selected) : null;

  const decisionDisabled =
    operatorMemo.trim().length < 12 || !ackChecked || !selected || selectedStatus !== "PENDING";

  return (
    <main className="min-h-screen">
      {/* Header */}
      <header className="mx-auto w-full max-w-6xl px-6 py-6">
        <div className="flex flex-wrap items-start justify-between gap-4">
          <div>
            <div className="text-xs text-[color:var(--faint)]">Operator Console</div>
            <h1 className="mt-1 text-2xl font-semibold text-white">Proposal Inbox</h1>
            <p className="mt-2 max-w-2xl text-sm text-[color:var(--muted)]">
              Review proposals in a governed workflow. This UI is static-only: it models the full approval
              surface without touching Supabase or execution.
            </p>
          </div>

          <div className="rounded-2xl border border-[color:var(--line)] bg-black/35 p-4 shadow-edge">
            <div className="text-xs text-[color:var(--faint)]">Loop</div>
            <div className="mt-1 text-sm font-semibold text-white">Propose → Approve → Execute → Proof</div>
            <div className="mt-1 text-xs text-[color:var(--muted)]">No authority in UI. No side effects.</div>
          </div>
        </div>

        {/* Filters */}
        <div className="mt-6 rounded-2xl border border-[color:var(--line)] bg-black/35 p-5 shadow-edge">
          <div className="flex flex-wrap items-center gap-3">
            <div className="flex-1 min-w-[240px]">
              <label className="text-xs text-[color:var(--faint)]">Search</label>
              <input
                value={query}
                onChange={(e) => setQuery(e.target.value)}
                placeholder="ID, title, target…"
                className="mt-2 w-full rounded-xl border border-[color:var(--line)] bg-black/30 px-3 py-2 text-sm text-white placeholder:text-[color:var(--muted)] focus:outline-none focus:ring-2 focus:ring-[color:var(--ring)]"
              />
            </div>

            <div className="min-w-[170px]">
              <label className="text-xs text-[color:var(--faint)]">Status</label>
              <select
                value={statusFilter}
                onChange={(e) => setStatusFilter(e.target.value as any)}
                className="mt-2 w-full rounded-xl border border-[color:var(--line)] bg-black/30 px-3 py-2 text-sm text-white focus:outline-none focus:ring-2 focus:ring-[color:var(--ring)]"
              >
                <option value="PENDING">PENDING</option>
                <option value="APPROVED">APPROVED</option>
                <option value="REJECTED">REJECTED</option>
                <option value="EXPIRED">EXPIRED</option>
                <option value="BLOCKED">BLOCKED</option>
                <option value="ALL">ALL</option>
              </select>
            </div>

            <div className="min-w-[170px]">
              <label className="text-xs text-[color:var(--faint)]">Risk</label>
              <select
                value={riskFilter}
                onChange={(e) => setRiskFilter(e.target.value as any)}
                className="mt-2 w-full rounded-xl border border-[color:var(--line)] bg-black/30 px-3 py-2 text-sm text-white focus:outline-none focus:ring-2 focus:ring-[color:var(--ring)]"
              >
                <option value="ALL">ALL</option>
                <option value="LOW">LOW</option>
                <option value="MEDIUM">MEDIUM</option>
                <option value="HIGH">HIGH</option>
              </select>
            </div>

            <div className="ml-auto flex items-center gap-2">
              <Pill tone="muted">{filtered.length} visible</Pill>
              <Pill tone="gold">static-only</Pill>
            </div>
          </div>
        </div>
      </header>

      {/* Table */}
      <section className="mx-auto w-full max-w-6xl px-6 pb-16">
        <div className="rounded-2xl border border-[color:var(--line)] bg-black/35 shadow-edge">
          <div className="px-6 py-5">
            <SectionTitle
              title="Inbox"
              desc="Select a proposal to review scope, gates, and make an explicit decision."
            />
          </div>

          <div className="h-px w-full bg-[color:var(--line)] opacity-60" />

          <div className="overflow-x-auto">
            <table className="w-full min-w-[900px] text-left text-sm">
              <thead className="text-xs text-[color:var(--faint)]">
                <tr className="border-b border-[color:var(--line)]">
                  <th className="px-6 py-4 font-medium">Proposal</th>
                  <th className="px-6 py-4 font-medium">Target</th>
                  <th className="px-6 py-4 font-medium">Risk</th>
                  <th className="px-6 py-4 font-medium">Status</th>
                  <th className="px-6 py-4 font-medium">Created</th>
                  <th className="px-6 py-4 font-medium text-right">Action</th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((p) => {
                  const st = effectiveStatus(p);
                  return (
                    <tr
                      key={p.id}
                      className="border-b border-[color:var(--line)] last:border-b-0 hover:bg-white/[0.03]"
                    >
                      <td className="px-6 py-4">
                        <div className="text-white font-semibold">{p.title}</div>
                        <div className="mt-1 text-xs text-[color:var(--muted)]">
                          <span className="font-medium text-[color:var(--gold2)]">{p.id}</span>{" "}
                          <span className="opacity-60">•</span> {p.summary}
                        </div>
                      </td>

                      <td className="px-6 py-4">
                        <div className="text-white">{p.scope.target}</div>
                        <div className="mt-1 text-xs text-[color:var(--muted)]">{p.scope.change}</div>
                      </td>

                      <td className="px-6 py-4">
                        <Pill tone={riskTone(p.risk)}>{p.risk}</Pill>
                      </td>

                      <td className="px-6 py-4">
                        <Pill tone={statusTone(st)}>{st}</Pill>
                      </td>

                      <td className="px-6 py-4 text-[color:var(--muted)]">{p.createdAt}</td>

                      <td className="px-6 py-4 text-right">
                        <Button variant="ghost" onClick={() => openReview(p)}>
                          Review
                        </Button>
                      </td>
                    </tr>
                  );
                })}

                {filtered.length === 0 ? (
                  <tr>
                    <td colSpan={6} className="px-6 py-10 text-center text-[color:var(--muted)]">
                      No proposals match your filters.
                    </td>
                  </tr>
                ) : null}
              </tbody>
            </table>
          </div>
        </div>
      </section>

      {/* Review modal */}
      <Modal
        open={!!selected}
        title={selected ? `${selected.title}` : "Proposal"}
        subtitle={
          selected
            ? `${selected.id} • ${selected.createdAt} • Tenant: ${selected.scope.tenant}`
            : undefined
        }
        onClose={closeAll}
        footer={
          selected ? (
            <>
              <div className="mr-auto flex flex-wrap items-center gap-2">
                <Pill tone={riskTone(selected.risk)}>Risk: {selected.risk}</Pill>
                <Pill tone={statusTone(selectedStatus ?? "PENDING")}>
                  Status: {selectedStatus ?? "PENDING"}
                </Pill>
              </div>

              <Button
                variant="ghost"
                onClick={() => openDecision("REJECT")}
                disabled={(selectedStatus ?? "PENDING") !== "PENDING"}
              >
                Reject
              </Button>
              <Button
                onClick={() => openDecision("APPROVE")}
                disabled={(selectedStatus ?? "PENDING") !== "PENDING"}
              >
                Approve
              </Button>
            </>
          ) : null
        }
      >
        {selected ? (
          <div className="grid gap-4 md:grid-cols-2">
            {/* Scope */}
            <div className="rounded-2xl border border-[color:var(--line)] bg-black/30 p-4">
              <div className="text-xs text-[color:var(--faint)]">Scope</div>
              <div className="mt-2 space-y-2 text-sm">
                <div>
                  <div className="text-xs text-[color:var(--muted)]">Target</div>
                  <div className="text-white font-medium">{selected.scope.target}</div>
                </div>
                <div>
                  <div className="text-xs text-[color:var(--muted)]">Change</div>
                  <div className="text-white font-medium">{selected.scope.change}</div>
                </div>
              </div>
            </div>

            {/* Gates */}
            <div className="rounded-2xl border border-[color:var(--line)] bg-black/30 p-4">
              <div className="text-xs text-[color:var(--faint)]">Governance gates (preview)</div>
              <div className="mt-3 space-y-2">
                {selected.gates.map((g, idx) => {
                  const tone =
                    g.state === "PASS" ? "green" : g.state === "FAIL" ? "red" : "muted";
                  return (
                    <div
                      key={idx}
                      className="rounded-xl border border-[color:var(--line)] bg-black/20 p-3"
                    >
                      <div className="flex items-center justify-between gap-3">
                        <div className="text-sm font-semibold text-white">{g.name}</div>
                        <Pill tone={tone}>{g.state}</Pill>
                      </div>
                      <div className="mt-1 text-xs text-[color:var(--muted)]">{g.detail}</div>
                    </div>
                  );
                })}
              </div>
            </div>

            {/* Operator memo */}
            <div className="md:col-span-2 rounded-2xl border border-[color:var(--line)] bg-black/30 p-4">
              <div className="text-xs text-[color:var(--faint)]">Operator decision memo</div>
              <div className="mt-2 text-xs text-[color:var(--muted)]">
                {selected.memoHint ??
                  "Write why this should be approved/rejected. This becomes the audit narrative."}
              </div>

              <textarea
                value={operatorMemo}
                onChange={(e) => setOperatorMemo(e.target.value)}
                rows={4}
                placeholder="Write the reason, evidence, and expected outcome…"
                className="mt-3 w-full rounded-xl border border-[color:var(--line)] bg-black/20 px-3 py-2 text-sm text-white placeholder:text-[color:var(--muted)] focus:outline-none focus:ring-2 focus:ring-[color:var(--ring)]"
              />

              <label className="mt-3 flex items-start gap-3 text-sm text-[color:var(--muted)]">
                <input
                  type="checkbox"
                  checked={ackChecked}
                  onChange={(e) => setAckChecked(e.target.checked)}
                  className="mt-1 h-4 w-4 accent-[color:var(--gold2)]"
                />
                <span>
                  I understand this decision is attributable, time-bound in real execution, and must produce proof
                  artifacts. No silent authority.
                </span>
              </label>

              <div className="mt-3 flex flex-wrap gap-2">
                <Pill tone="muted">Decision requires memo ≥ 12 chars</Pill>
                <Pill tone="muted">Ack required</Pill>
                <Pill tone="gold">Execution not enabled in this UI</Pill>
              </div>
            </div>
          </div>
        ) : null}
      </Modal>

      {/* Decision modal */}
      <Modal
        open={decisionOpen}
        title={decisionType === "APPROVE" ? "Confirm Approval" : "Confirm Rejection"}
        subtitle={
          selected
            ? `${selected.id} • ${selected.title}`
            : undefined
        }
        onClose={() => setDecisionOpen(false)}
        footer={
          <>
            <Button variant="ghost" onClick={() => setDecisionOpen(false)}>
              Cancel
            </Button>
            <Button
              variant={decisionType === "REJECT" ? "danger" : "primary"}
              onClick={confirmDecision}
              disabled={decisionDisabled}
            >
              {decisionType === "APPROVE" ? "Approve (static)" : "Reject (static)"}
            </Button>
          </>
        }
      >
        {selected ? (
          <div className="space-y-4">
            <div className="rounded-2xl border border-[color:var(--line)] bg-black/30 p-4">
              <div className="flex flex-wrap items-center justify-between gap-3">
                <div>
                  <div className="text-xs text-[color:var(--faint)]">Scope</div>
                  <div className="mt-1 text-sm font-semibold text-white">{selected.scope.target}</div>
                  <div className="mt-1 text-xs text-[color:var(--muted)]">{selected.scope.change}</div>
                </div>
                <div className="flex items-center gap-2">
                  <Pill tone={riskTone(selected.risk)}>Risk: {selected.risk}</Pill>
                  <Pill tone={statusTone(selectedStatus ?? "PENDING")}>
                    Current: {selectedStatus ?? "PENDING"}
                  </Pill>
                </div>
              </div>
            </div>

            <div className="rounded-2xl border border-[color:var(--line)] bg-black/30 p-4">
              <div className="text-xs text-[color:var(--faint)]">You are confirming:</div>
              <div className="mt-2 text-sm text-white">
                {decisionType === "APPROVE"
                  ? "This proposal is approved for execution (in a future governed path)."
                  : "This proposal is rejected and will not execute."}
              </div>
              <div className="mt-2 text-xs text-[color:var(--muted)]">
                In real operation: approval becomes single-use, time-bound, and audited. This screen is modeling that
                decision surface only.
              </div>
            </div>

            <div className="rounded-2xl border border-[color:var(--line)] bg-black/30 p-4">
              <div className="text-xs text-[color:var(--faint)]">Decision memo (required)</div>
              <div className="mt-2 text-xs text-[color:var(--muted)]">
                Minimum 12 characters. Must be attributable and reasoned.
              </div>
              <div className="mt-3 rounded-xl border border-[color:var(--line)] bg-black/20 p-3 text-sm text-white">
                {operatorMemo.trim() ? operatorMemo : <span className="text-[color:var(--muted)]">— empty —</span>}
              </div>

              <div className="mt-3 text-xs text-[color:var(--muted)]">
                Ack:{" "}
                <span className={ackChecked ? "text-emerald-200" : "text-rose-200"}>
                  {ackChecked ? "checked" : "not checked"}
                </span>
              </div>
            </div>
          </div>
        ) : null}
      </Modal>
    </main>
  );
}
