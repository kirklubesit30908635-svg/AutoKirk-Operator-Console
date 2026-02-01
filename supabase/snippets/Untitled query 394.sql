-- 2) seed founder (idempotent)
insert into
  founder.founders (user_id, status)
values
  ('aa660c58-db58-4e5a-8686-9b18c717b59b', 'active')
on conflict (user_id) do update
set
  status = excluded.status;

-- 3) canonical gate
create or replace function public.is_founder () returns boolean language sql stable security definer
set
  search_path = public,
  founder,
  auth as $$
  select exists (
    select 1
    from founder.founders f
    where f.user_id = auth.uid()
      and f.status = 'active'
  );
$$;

revoke all on function public.is_founder ()
from
  public;

grant
execute on function public.is_founder () to authenticated;

grant
execute on function public.is_founder () to service_role;