select
  n.nspname as schema,
  p.proname as function,
  pg_get_functiondef(p.oid) as def
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where pg_get_functiondef(p.oid) ilike '%ak.is_founder%';
