create or replace function ak.is_founder()
returns boolean
language sql
stable
security definer
set search_path = public, ak, founder, auth
as $$
  select public.is_founder();
$$;

revoke all on function ak.is_founder() from public;
grant execute on function ak.is_founder() to authenticated;
grant execute on function ak.is_founder() to service_role;
