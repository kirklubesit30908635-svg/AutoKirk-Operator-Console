-- 05_rate_limit.sql

create table if not exists public.kdh_rate_limits (
  user_id uuid not null,
  window_start timestamptz not null,
  count integer not null default 0,
  primary key (user_id, window_start)
);

alter table public.kdh_rate_limits enable row level security;

drop policy if exists "founder select kdh_rate_limits" on public.kdh_rate_limits;
create policy "founder select kdh_rate_limits"
on public.kdh_rate_limits
for select
to authenticated
using (public.is_founder());

drop policy if exists "founder insert kdh_rate_limits" on public.kdh_rate_limits;
create policy "founder insert kdh_rate_limits"
on public.kdh_rate_limits
for insert
to authenticated
with check (public.is_founder());

drop policy if exists "founder update kdh_rate_limits" on public.kdh_rate_limits;
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
