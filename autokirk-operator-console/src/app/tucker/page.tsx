'use client'

import { useEffect, useMemo, useState } from 'react'
import { createClient } from '@/lib/supabase/supabaseBrowser'

type Obligation = {
  id: string
  promise_id: string
  due_at: string | null
  severity: string
}

type CloseOutcome = 'won' | 'lost' | 'dead'

export default function TuckerNextActionsPage() {
  const supabase = useMemo(() => createClient(), [])

  const [items, setItems] = useState<Obligation[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [closingPromiseId, setClosingPromiseId] = useState<string | null>(null)
  const [closeError, setCloseError] = useState<string | null>(null)

  const load = async () => {
    setLoading(true)
    setError(null)

    const { data, error } = await supabase
      .schema('tucker')
      .from('v_current_open_obligations')
      .select('id, promise_id, due_at, severity')
      .order('due_at', { ascending: true })

    if (error) {
      setError(error.message)
      setItems([])
    } else {
      setItems(data ?? [])
    }

    setLoading(false)
  }

  const closePromise = async (promiseId: string, outcome: CloseOutcome) => {
    setClosingPromiseId(promiseId)
    setCloseError(null)

    const reason = window.prompt('Reason code', 'manual_test')
    if (!reason) {
      setClosingPromiseId(null)
      return
    }

    const requestId = crypto.randomUUID()

    const { error } = await supabase.rpc('api.fn_close_promise_v2', {
      p_promise_id: promiseId,
      p_outcome: outcome,
      p_revenue_amount: null,
      p_reason_code: reason,
      p_request_id: requestId,
    })

    if (error) {
      setCloseError(error.message)
      setClosingPromiseId(null)
      return
    }

    await load()
    setClosingPromiseId(null)
  }

  useEffect(() => {
    load()
  }, [])

  return (
    <div className="p-6 max-w-3xl mx-auto">
      <h1 className="text-xl font-semibold mb-4">
        What do I need to do next?
      </h1>

      <button onClick={load} className="mb-4 px-3 py-1 border rounded">
        Refresh
      </button>

      {error && <div className="mb-4">Error: {error}</div>}
      {closeError && <div className="mb-4">Close error: {closeError}</div>}

      <ul className="space-y-4">
        {items.map((o) => (
          <li key={o.id} className="border rounded p-4">
            <div>Due: {o.due_at}</div>
            <div>Severity: {o.severity}</div>
            <div>Promise: {o.promise_id}</div>
            <div>Obligation: {o.id}</div>

            <div className="mt-2 space-x-2">
              <button
                disabled={closingPromiseId === o.promise_id}
                onClick={() => closePromise(o.promise_id, 'won')}
              >
                Close Won
              </button>
              <button
                disabled={closingPromiseId === o.promise_id}
                onClick={() => closePromise(o.promise_id, 'lost')}
              >
                Close Lost
              </button>
              <button
                disabled={closingPromiseId === o.promise_id}
                onClick={() => closePromise(o.promise_id, 'dead')}
              >
                Close Dead
              </button>
            </div>
          </li>
        ))}
      </ul>
    </div>
  )
}
