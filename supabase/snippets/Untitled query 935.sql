-- 0) Hard requirement: RLS must be on for the authority table
alter table if exists founder.founders enable row level security;

-- 1) Lock down direct access (authority should be checked via ak.is_founder(), not queried)
revoke all on table founder.founders from public;
revoke all on table founder.founders from anon;
revoke all on table founder.founders from authenticated;

-- 2) Minimal RLS: allow NO direct reads/writes from normal roles
drop policy if exists "founders_no_access" on founder.founders;
create policy "founders_no_access"
on founder.founders
for all
to public
using (false)
with check (false);

-- 3) Make public.is_founder() a strict alias of ak.is_founder()
create or replace function public.is_founder()
returns boolean
language sql
stable
security definer
set search_path = ak, public
as $$
  select ak.is_founder();
$$;

revoke all on function public.is_founder() from public;
grant execute on function public.is_founder() to authenticated;