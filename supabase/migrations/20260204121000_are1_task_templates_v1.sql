-- 20260204121000_are1_task_templates_v1.sql
-- ARE-1 Task Templates (org-scoped only; founder-only)
-- No global templates in V1 to avoid platform-founder leakage.

begin;

create table if not exists public.task_templates (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),

  org_id uuid not null references public.orgs(id) on delete cascade,

  task_type public.task_type not null,
  title text not null,
  directive text not null,

  default_due_hours integer null
    check (default_due_hours is null or default_due_hours between 1 and 720),

  founder_locked boolean not null default true,

  status text not null default 'active'
    check (status in ('active','archived'))
);

alter table public.task_templates enable row level security;

-- Founder-only read/write
drop policy if exists task_templates_select on public.task_templates;
create policy task_templates_select on public.task_templates
for select using (public.is_founder(org_id));

drop policy if exists task_templates_insert on public.task_templates;
create policy task_templates_insert on public.task_templates
for insert with check (public.is_founder(org_id));

drop policy if exists task_templates_update on public.task_templates;
create policy task_templates_update on public.task_templates
for update using (public.is_founder(org_id))
with check (public.is_founder(org_id));

-- Optional: close deletes (soft-delete via status)
drop policy if exists task_templates_delete on public.task_templates;
create policy task_templates_delete on public.task_templates
for delete using (false);

create index if not exists idx_task_templates_org on public.task_templates(org_id);

commit;
