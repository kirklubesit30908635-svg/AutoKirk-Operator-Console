import { createClient } from '@/lib/supabaseBrowser'

export default async function TuckerPage() {
  const supabase = createClient()

  const { data, error } = await supabase
    .schema('api')
    .from('v_current_open_obligations')
    .select('*')
    .order('due_at', { ascending: true })

  return (
    <main style={{ padding: 32 }}>
      <h1 style={{ fontSize: 48, fontWeight: 700 }}>
        What do I need to do next?
      </h1>

      <p>
        <a href="/tucker">Refresh</a>
      </p>

      {error && (
        <pre style={{ color: 'red' }}>
          Error: {error.message}
        </pre>
      )}

      {!data?.length && !error && (
        <p>No open obligations.</p>
      )}

      {data?.map((o: any) => (
        <div key={o.id} style={{ marginTop: 16 }}>
          <div>Due: {o.due_at}</div>
          <div>Severity: {o.severity}</div>
          <div>Promise: {o.promise_id}</div>
          <div>Obligation: {o.id}</div>
        </div>
      ))}
    </main>
  )
}
