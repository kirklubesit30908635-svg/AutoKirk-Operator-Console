'use client'

import { useEffect, useState } from 'react'
import { createClient } from '@/lib/supabase/supabaseBrowser'

type Obligation = {
  id: string
  promise_id: string
  due_at: string
  severity: 'normal' | 'critical'
}

export default function TuckerNextActionsPage() {
  const supabase = createClient()

  const [items, setItems] = useState<Obligation[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const load = async () => {
    setLoading(true)
    setError(null)

    const { data, error } = await supabase
      .from('v_current_open_obligations')
      .select('id, promise_id, due_at, severity')
      .order('due_at', { ascending: true })
      .limit(100)

    if (error) {
      setError(error.message)
      setItems([])
    } else {
      setItems(data ?? [])
    }

    setLoading(false)
  }

  useEffect(() => {
    load()
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

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

      {!loading && !error && items.length === 0 && (
        <div className='border rounded p-3'>Nothing open.</div>
      )}

      {!loading && !error && items.length > 0 && (
        <ul className='space-y-3'>
          {items.map((o) => (
            <li key={o.id} className='border rounded p-4'>
              <div className='text-sm'>
                <span className='font-semibold'>Due:</span>{' '}
                {new Date(o.due_at).toLocaleString()}
              </div>

              <div className='text-sm'>
                <span className='font-semibold'>Severity:</span> {o.severity}
              </div>

              <div className='text-xs opacity-70 mt-1'>Promise: {o.promise_id}</div>
              <div className='text-xs opacity-70'>Obligation: {o.id}</div>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
