export default function ProposalInboxPage() {
  return (
    <main className="mx-auto max-w-5xl px-4 py-8 space-y-8">
      {/* Header */}
      <header className="space-y-2">
        <h1 className="text-3xl font-semibold text-white">
          Proposal Inbox
        </h1>
        <p className="text-sm text-neutral-400 max-w-2xl">
          Review and approve AI-proposed actions before they affect your system.
        </p>
      </header>

      {/* How actions happen */}
      <section className="rounded-xl border border-neutral-800 bg-neutral-900/50 p-5">
        <h2 className="text-sm font-medium text-neutral-300 mb-1">
          How actions happen
        </h2>
        <p className="text-sm text-neutral-200 font-medium">
          Propose → Approve → Execute → Proof
        </p>
        <p className="mt-2 text-sm text-neutral-400 max-w-2xl">
          Nothing executes without your approval. Every action produces a
          permanent record you can inspect or reverse.
        </p>
      </section>

      {/* Filters */}
      <section className="rounded-xl border border-neutral-800 bg-neutral-900/50 p-5 space-y-4">
        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <div>
            <label className="block text-xs text-neutral-400 mb-1">
              Search proposals
            </label>
            <input
              placeholder="ID, title, target…"
              className="w-full rounded-md bg-neutral-950 border border-neutral-800 px-3 py-2 text-sm text-white placeholder-neutral-600"
            />
          </div>

          <div>
            <label className="block text-xs text-neutral-400 mb-1">
              Status
            </label>
            <select className="w-full rounded-md bg-neutral-950 border border-neutral-800 px-3 py-2 text-sm text-white">
              <option>PENDING</option>
              <option>APPROVED</option>
              <option>DENIED</option>
              <option>EXECUTED</option>
            </select>
          </div>

          <div>
            <label className="block text-xs text-neutral-400 mb-1">
              Risk level
            </label>
            <select className="w-full rounded-md bg-neutral-950 border border-neutral-800 px-3 py-2 text-sm text-white">
              <option>ALL</option>
              <option>LOW</option>
              <option>MEDIUM</option>
              <option>HIGH</option>
            </select>
          </div>
        </div>
      </section>

      {/* Inbox */}
      <section className="space-y-3">
        <div>
          <h2 className="text-lg font-medium text-white">
            Pending decisions
          </h2>
          <p className="text-sm text-neutral-400">
            Review scope, impact, and safeguards before approving execution.
          </p>
        </div>

        <ul className="space-y-3">
          {/* Proposal */}
          <li className="rounded-xl border border-neutral-800 bg-neutral-900/50 p-4 hover:border-neutral-700 transition">
            <div className="flex justify-between items-start gap-4">
              <div className="space-y-1">
                <p className="font-medium text-white">
                  Rotate public API key reference
                </p>
                <p className="text-sm text-neutral-400">
                  <span className="text-neutral-300">P-00112</span> · Client-only env update · No secret exposure
                </p>
              </div>
              <span className="text-xs rounded-full border border-neutral-700 px-2 py-1 text-neutral-300">
                Low risk
              </span>
            </div>
          </li>

          {/* Proposal */}
          <li className="rounded-xl border border-neutral-800 bg-neutral-900/50 p-4 hover:border-neutral-700 transition">
            <div className="flex justify-between items-start gap-4">
              <div className="space-y-1">
                <p className="font-medium text-white">
                  Change system safety state
                </p>
                <p className="text-sm text-neutral-400">
                  <span className="text-neutral-300">P-00094</span> · Set <code className="text-neutral-300">arm_state</code> → DISARMED · Governed execution with proof
                </p>
              </div>
              <span className="text-xs rounded-full border border-neutral-700 px-2 py-1 text-neutral-300">
                Medium risk
              </span>
            </div>
          </li>
        </ul>

        {/* Reassurance */}
        <p className="pt-4 text-xs text-neutral-500">
          Every approval is single-use, time-bound, and fully auditable.
        </p>
      </section>
    </main>
  );
}
