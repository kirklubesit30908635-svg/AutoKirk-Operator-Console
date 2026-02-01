select
  n.nspname as schema,
  p.proname as function,
  pg_get_function_identity_arguments(p.oid) as args,
  pg_get_function_result(p.oid) as returns
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where (n.nspname, p.proname) in (('public','is_founder'), ('ak','is_founder'))
order by 1,2;
