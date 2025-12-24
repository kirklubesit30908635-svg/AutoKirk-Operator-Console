-- 00_profiles_founder_role.sql
-- Add 'founder' to profile_role enum if missing, then set your user to founder.
-- Run in Supabase SQL Editor.

do $$
begin
  if not exists (
    select 1
    from pg_type t
    join pg_enum e on t.oid = e.enumtypid
    join pg_namespace n on n.oid = t.typnamespace
    where n.nspname = 'public'
      and t.typname = 'profile_role'
      and e.enumlabel = 'founder'
  ) then
    execute 'alter type public.profile_role add value ''founder''';
  end if;
end $$;

-- After you have a user, set them to founder by UUID:
-- update public.profiles set role = 'founder' where id = 'YOUR_AUTH_USER_UUID';
