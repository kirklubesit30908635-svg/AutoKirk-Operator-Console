-- 01_is_founder_function.sql
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
