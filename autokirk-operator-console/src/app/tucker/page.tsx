'use client'

import { useEffect, useMemo, useState } from 'react'
import { createClient } from '@/lib/supabase/supabaseBrowser'

type Obligation = {
  id: string
  promise_id: string
  due_at: string | null
  severity: 'normal' | 'critical' | 'warning' | 'info'
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
      .order('due_at', { ascending: true, nullsFirst: false })
      .limit(100)

    if (error) {
      setError(error.message)
      setItems([])
    } else {
      setItems((data ?? []) as Obligation[])
    }

    setLoading(false)
  }

  const closePromise = async (promiseId: string, outcome: CloseOutcome) => {
    setClosingPromiseId(promiseId)
    setCloseError(null)

    // Collect required inputs (minimal, fast)
    let revenueAmount: number | null = null
    let reasonCode: string | null = null

    if (outcome === 'won') {
      const rev = window.prompt('Revenue amount? (numbers only)', '0')
      if (rev === null) {
        setClosingPromiseId(null)
        return
      }
      const parsed = Number(rev)
      if (!Number.isFinite(parsed) || parsed < 0) {
        setCloseError('Invalid revenue amount.')
        setClosingPromiseId(null)
        return
      }
      revenueAmount = parsed

      const reason = window.prompt('Reason code? (e.g. customer_signed)', 'customer_signed')
      if (reason === null || reason.trim().length === 0) {
        setCloseError('Reason code is required.')
        setClosingPromiseId(null)
        return
      }
      reasonCode = reason.trim()
    } else {
      const defaultReason = outcome === 'lost' ? 'lost_to_competitor' : 'no_response'
      const reason = window.prompt(
        `Reason code? (e.g. ${defaultReason})`,
        defaultReason
      )
      if (reason === null || reason.trim().length === 0) {
        setCloseError('Reason code is required.')
        setClosingPromiseId(null)
        return
      }
      reasonCode = reason.trim()
    }

    const requestId =
      typeof crypto !== 'undefined' && 'randomUUID' in crypto
        ? crypto.randomUUID()
        : `${Date.now()}-${Math.random()}`

    // NOTE: This assumes fn_close_promise_v2 signature:
    // (promise_id uuid, outcome text, revenue_amount numeric, reason_code text, request_id uuid)
    const { error } = await supabase.rpc('fn_close_promise_v2', {
      p_promise_id: promiseId,
      p_outcome: outcome,
      p_revenue_amount: revenueAmount,
      p_reason_code: reasonCode,
      p_request_id: requestId,
    })

    if (error) {
      setCloseError(error.message)
      setClosingPromiseId(null)
      return
    }

    // Refresh list after successful closure
    await load()
    setClosingPromiseId(null)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const formatDue = (dueAt: string | null) => {
    if (!dueAt) return '—'
    const d = new Date(dueAt)
    return Number.isNaN(d.getTime()) ? dueAt : d.toLocaleString()
  }

  return (
    <div className='p-6 max-w-3xl mx-auto'>
      <div className='flex items-baseline justify-between mb-4'>
        <h1 className='text-xl font-semibold'>What do I need to do next?</h1>

        <button onClick={load} className='px-3 py-1 rounded border'>
          Refresh
        </button>
      </div>

      {loading && <div>Loading obligations…</div>}

      {!loading && error && (
        <div className='border rounded p-3 text-sm'>Error: {error}</div>
      )}

      {!loading && !error && closeError && (
        <div className='border rounded p-3 text-sm'>Close error: {closeError}</div>
      )}

      {!loading && !error && items.length === 0 && (
        <div className='border rounded p-3'>Nothing open.</div>
      )}

      {!loading && !error && items.length > 0 && (
        <ul className='space-y-3'>
          {items.map((o) => {
            const isClosing = closingPromiseId === o.promise_id
            return (
              <li key={o.id} className='border rounded p-4'>
                <div className='flex items-start justify-between gap-4'>
                  <div className='min-w-0'>
                    <div className='text-sm'>
                      <span className='font-semibold'>Due:</span> {formatDue(o.due_at)}
                    </div>

                    <div className='text-sm'>
                      <span className='font-semibold'>Severity:</span> {o.severity}
                    </div>

                    <div className='text-xs opacity-70 mt-1 break-all'>
                      Promise: {o.promise_id}
                    </div>
                    <div className='text-xs opacity-70 break-all'>Obligation: {o.id}</div>
                  </div>

                  <div className='flex flex-col gap-2 shrink-0'>
                    <button
                      disabled={isClosing}
                      onClick={() => closePromise(o.promise_id, 'won')}
                      className='px-3 py-1 rounded border'
                      title='Close promise as WON'
                    >
                      {isClosing ? 'Closing…' : 'Close Won'}
                    </button>

                    <button
                      disabled={isClosing}
                      onClick={() => closePromise(o.promise_id, 'lost')}
                      className='px-3 py-1 rounded border'
                      title='Close promise as LOST'
                    >
                      {isClosing ? 'Closing…' : 'Close Lost'}
                    </button>

                    <button
                      disabled={isClosing}
                      onClick={() => closePromise(o.promise_id, 'dead')}
                      className='px-3 py-1 rounded border'
                      title='Close promise as DEAD'
                    >
                      {isClosing ? 'Closing…' : 'Close Dead'}
                    </button>
                  </div>
                </div>
              </li>
            )
          })}
        </ul>
      )}
    </div>
  )
}
