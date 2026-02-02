select
  n.nspname as schema,
  p.proname as function,
  p.oid::regprocedure as signature
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where p.prosrc ilike '%ak.is_founder%';
