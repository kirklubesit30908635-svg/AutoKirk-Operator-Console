select set_config(
  'request.jwt.claim.sub',
  'aa660c58-db58-4e5a-8686-9b18c717b59b',
  false  -- IMPORTANT: persist for session, not just the transaction
);

select
  auth.uid() as uid,
  public.is_founder() as public_is_founder;
