# Kirk Digital Holdings — Founder Chat (MVP)

Private founder-only chat surface intended to deploy at: `kirkdigitalholdings.com/founder`

## Stack
- Next.js (App Router)
- Supabase Auth + Postgres (tables: `mvp_threads`, `mvp_messages`, `vault_entries`)
- OpenAI (server-side proxy only)

## Critical Security Posture
- No OpenAI API key in the browser (only on server).
- All Supabase tables protected by RLS; access is gated by `profiles.role = 'founder'`.

---

## 1) Supabase prerequisites

### A) Ensure `profiles.role` can be 'founder'
If your enum does not include `founder`:

```sql
alter type public.profile_role add value if not exists 'founder';
```

Ensure your user is marked founder:

```sql
insert into public.profiles (id, email, role)
values (auth.uid(), null, 'founder')
on conflict (id) do update set role = 'founder';
```

### B) Enable RLS on MVP tables and apply founder-only policies

```sql
alter table public.mvp_threads enable row level security;
alter table public.mvp_messages enable row level security;

create or replace function public.is_founder()
returns boolean
language sql
stable
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'founder'
  );
$$;

create policy "founder select mvp_threads"
on public.mvp_threads
for select
to authenticated
using (public.is_founder());

create policy "founder insert mvp_threads"
on public.mvp_threads
for insert
to authenticated
with check (public.is_founder());

create policy "founder select mvp_messages"
on public.mvp_messages
for select
to authenticated
using (public.is_founder());

create policy "founder insert mvp_messages"
on public.mvp_messages
for insert
to authenticated
with check (public.is_founder());
```

### C) Vault lock support (optional but recommended)
This app writes locks into `vault_entries`. Ensure your RLS permits founders:

```sql
alter table public.vault_entries enable row level security;

create policy "founder select vault_entries"
on public.vault_entries
for select
to authenticated
using (public.is_founder());

create policy "founder insert vault_entries"
on public.vault_entries
for insert
to authenticated
with check (public.is_founder());
```

---

## 2) Configure environment variables

Copy `.env.example` to `.env.local` and set:

- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `OPENAI_API_KEY`
- `OPENAI_MODEL` (optional)

---

## 3) Install and run

```bash
npm install
npm run dev
```

Open:
- `/founder/login` to sign in
- `/founder` to chat

---

## 4) Deployment notes

### Vercel (recommended)
- Add env vars in Vercel project settings
- Deploy
- Map `kirkdigitalholdings.com` and route `/founder`

### Netlify
Next.js works on Netlify, but Vercel is typically the shortest path. If you deploy to Netlify, use the Netlify Next.js runtime/plugin and set env vars.

---

## Operator Commands (built-in)
- `where are we` → audit + next action
- `lock this: <title>` → assistant will output a lock-ready object (and you can also click "LOCK" on any assistant message)
- `stop ideation` → scope reduction and execution plan

---

## 5) Safety hardening: Moderation gate (already wired)

The server `/api/chat` runs an OpenAI moderation check using `omni-moderation-latest`.
Flagged inputs are blocked and recorded as a `system` message in `mvp_messages`.

---

## 6) Efficiency hardening: Thread summaries (required)

Create a summary table + RLS:

```sql
create table if not exists public.mvp_thread_summaries (
  thread_id uuid primary key references public.mvp_threads(id) on delete cascade,
  summary text not null default '',
  updated_at timestamptz not null default now()
);

alter table public.mvp_thread_summaries enable row level security;

create policy "founder select mvp_thread_summaries"
on public.mvp_thread_summaries
for select
to authenticated
using (public.is_founder());

create policy "founder upsert mvp_thread_summaries"
on public.mvp_thread_summaries
for insert
to authenticated
with check (public.is_founder());

create policy "founder update mvp_thread_summaries"
on public.mvp_thread_summaries
for update
to authenticated
using (public.is_founder());
```

The app uses:
- `summary + last 20 messages` for prompt context (cost control)
- auto-updates summary every ~12 messages per thread (lightweight)

---

## 7) Abuse & cost control: Rate limiting (required)

Create a rate limit table + an atomic RPC function:

```sql
create table if not exists public.kdh_rate_limits (
  user_id uuid not null,
  window_start timestamptz not null,
  count integer not null default 0,
  primary key (user_id, window_start)
);

alter table public.kdh_rate_limits enable row level security;

create policy "founder select kdh_rate_limits"
on public.kdh_rate_limits
for select
to authenticated
using (public.is_founder());

create policy "founder insert kdh_rate_limits"
on public.kdh_rate_limits
for insert
to authenticated
with check (public.is_founder());

create policy "founder update kdh_rate_limits"
on public.kdh_rate_limits
for update
to authenticated
using (public.is_founder());

create or replace function public.kdh_check_rate_limit(max_requests integer, window_seconds integer)
returns jsonb
language plpgsql
security definer
as $$
declare
  uid uuid := auth.uid();
  now_ts timestamptz := now();
  wstart timestamptz := date_trunc('second', now_ts) - make_interval(secs => (extract(epoch from date_trunc('second', now_ts))::int % window_seconds));
  current_count integer;
begin
  if uid is null then
    return jsonb_build_object('ok', false, 'status', 401, 'error', 'Unauthorized');
  end if;

  insert into public.kdh_rate_limits(user_id, window_start, count)
  values (uid, wstart, 1)
  on conflict (user_id, window_start)
  do update set count = public.kdh_rate_limits.count + 1
  returning count into current_count;

  if current_count > max_requests then
    return jsonb_build_object('ok', false, 'status', 429, 'error', 'Rate limit exceeded', 'count', current_count, 'window_start', wstart);
  end if;

  return jsonb_build_object('ok', true, 'status', 200, 'count', current_count, 'window_start', wstart);
end;
$$;
```

Default limits used by the app:
- Founder: 20 requests / 60 seconds

