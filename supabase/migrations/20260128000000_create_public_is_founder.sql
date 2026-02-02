create schema if not exists founder;

-- OPTIONAL safeguard: only keep this block if founder.founders is NOT created elsewhere.
create table if not exists founder.founders (
  user_id uuid primary key
);

alter table founder.founders enable row level security;

revoke all on table founder.founders from public;
revoke all on table founder.founders from anon;
revoke all on table founder.founders from authenticated;

drop policy if exists "founders_no_access" on founder.founders;
create policy "founders_no_access"
on founder.founders
for all
to public
using (false)
with check (false);

create or replace function public.is_founder()
returns boolean
language sql
stable
security definer
set search_path = public, founder, pg_temp
as $$
  select exists (
    select 1
    from founder.founders f
    where f.user_id = auth.uid()
  );
$$;

revoke all on function public.is_founder() from public;
grant execute on function public.is_founder() to authenticated;
grant execute on function public.is_founder() to service_role;
