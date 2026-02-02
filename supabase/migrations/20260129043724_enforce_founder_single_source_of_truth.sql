-- Enforce single source of truth for founder gate.
-- ak.is_founder() becomes a thin wrapper around public.is_founder().

begin;

create schema if not exists ak;

create or replace function ak.is_founder()
returns boolean
language sql
stable
security definer
set search_path = public, founder, pg_temp
as $$
  select public.is_founder();
$$;

revoke all on function ak.is_founder() from public;
grant execute on function ak.is_founder() to anon, authenticated;

commit;
