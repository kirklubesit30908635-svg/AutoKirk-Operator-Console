-- supabase/seed.sql
-- Local dev seed for ARE-1 (NO BOM)

begin;

-- Fixed IDs so your UI config never changes between resets
insert into public.orgs (id, name, status)
values ('11111111-1111-1111-1111-111111111111', 'ARE-1 LOCAL TEST ORG', 'active')
on conflict (id) do nothing;

insert into public.task_templates (
  id, org_id, task_type, title, directive, default_due_hours, founder_locked, status
)
values (
  '22222222-2222-2222-2222-222222222222',
  '11111111-1111-1111-1111-111111111111',
  'offer_refine',
  'Refine Offer V1',
  'Tighten the target buyer + promise. Keep it concrete. No fluff.',
  24,
  true,
  'active'
)
on conflict (id) do nothing;

commit;