create or replace function public.is_founder()
returns boolean
language sql
stable
security definer
set search_path = public, founder, auth
as $$
  select exists (
    select 1
    from founder.founders f
    where f.user_id = auth.uid()
      and f.status = 'active'
  );
$$;

revoke all on function public.is_founder() from public;
grant execute on function public.is_founder() to authenticated;
grant execute on function public.is_founder() to service_role;
