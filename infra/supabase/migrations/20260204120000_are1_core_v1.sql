-- 20260204120000_are1_core_v1.sql
-- ARE-1 Core V1 (Live-ready)
-- Doctrine: Founder sovereign, Operators execute, Tasks are choke point, Audit is truth ledger.

begin;

-- Extensions
create extension if not exists pgcrypto;

-- =========================
-- 0) Enums
-- =========================

do $$ begin
  create type public.org_status as enum ('active','suspended','closed');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.org_role as enum ('founder','operator');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.asset_status as enum ('draft','active','archived');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.sequence_channel as enum ('email','sms','social','phone','multi');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.sequence_status as enum ('draft','active','paused','archived');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.script_type as enum ('opening','followup','objection','closing','voicemail','dm');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.script_status as enum ('active','archived');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.deal_stage as enum ('new','qualified','proposal','negotiation','closed_won','closed_lost');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.task_type as enum ('offer_refine','send_outbound','follow_up','deal_update','review_script','report_metrics');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.task_status as enum ('open','in_progress','blocked','done','cancelled');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.audit_surface as enum ('founder','primary','public');
exception when duplicate_object then null; end $$;

do $$ begin
  create type public.audit_result as enum ('ok','blocked','error');
exception when duplicate_object then null; end $$;

-- =========================
-- 1) Core Identity
-- =========================

create table if not exists public.orgs (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name text not null,
  status public.org_status not null default 'active',
  vertical text null
);

create table if not exists public.user_org_roles (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  user_id uuid not null references auth.users(id) on delete cascade,
  org_id uuid not null references public.orgs(id) on delete cascade,
  role public.org_role not null,
  unique (user_id, org_id)
);

-- =========================
-- 2) ARE-1 Objects (Execution artifacts only)
-- =========================

create table if not exists public.offers (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  org_id uuid not null references public.orgs(id) on delete cascade,
  owner_user_id uuid not null references auth.users(id) on delete restrict,

  name text not null,
  target_buyer text null,
  promise text null,
  price_cents integer null check (price_cents is null or price_cents >= 0),
  positioning text null,

  status public.asset_status not null default 'draft',
  founder_locked boolean not null default false
);

create table if not exists public.outbound_sequences (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  org_id uuid not null references public.orgs(id) on delete cascade,
  offer_id uuid null references public.offers(id) on delete set null,

  name text not null,
  channel public.sequence_channel not null default 'multi',
  status public.sequence_status not null default 'draft',

  founder_locked boolean not null default false
);

create table if not exists public.outbound_scripts (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  org_id uuid not null references public.orgs(id) on delete cascade,
  sequence_id uuid null references public.outbound_sequences(id) on delete set null,
  offer_id uuid null references public.offers(id) on delete set null,

  name text not null,
  script_type public.script_type not null,
  content text not null, -- human-readable script only
  status public.script_status not null default 'active',

  founder_locked boolean not null default false
);

create table if not exists public.deals (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  org_id uuid not null references public.orgs(id) on delete cascade,
  offer_id uuid null references public.offers(id) on delete set null,

  lead_label text null, -- intentionally non-sensitive V1
  stage public.deal_stage not null default 'new',

  value_cents integer null check (value_cents is null or value_cents >= 0),
  last_action_at timestamptz null,
  notes text null
);

create table if not exists public.deal_objections (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  org_id uuid not null references public.orgs(id) on delete cascade,
  deal_id uuid not null references public.deals(id) on delete cascade,

  objection_code text not null,
  objection_text text null,
  routed_path text null,
  resolved boolean not null default false
);

create table if not exists public.performance_snapshots (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  org_id uuid not null references public.orgs(id) on delete cascade,

  period_start date not null,
  period_end date not null,
  constraint perf_period_valid check (period_end >= period_start),

  outreaches integer not null default 0 check (outreaches >= 0),
  replies integer not null default 0 check (replies >= 0),
  booked integer not null default 0 check (booked >= 0),
  closes integer not null default 0 check (closes >= 0),
  revenue_cents integer not null default 0 check (revenue_cents >= 0),

  failure_flags jsonb not null default '{}'::jsonb
);

-- Task feed = choke point
create table if not exists public.operator_tasks (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  org_id uuid not null references public.orgs(id) on delete cascade,

  issuer_user_id uuid not null references auth.users(id) on delete restrict,

  task_type public.task_type not null,
  title text not null,
  directive text not null,

  status public.task_status not null default 'open',

  due_at timestamptz null,
  completed_at timestamptz null,

  result_note text null, -- operator can write via RPC only
  founder_locked boolean not null default true
);

-- =========================
-- 3) Audit (append-only + non-forgeable)
-- =========================

create table if not exists public.audit_events (
  event_id uuid primary key default gen_random_uuid(),
  ts timestamptz not null default now(),

  org_id uuid null references public.orgs(id) on delete set null,
  actor_user_id uuid null references auth.users(id) on delete set null,

  actor_role public.org_role null,
  surface public.audit_surface not null default 'primary',

  action text not null,
  target text null,
  result public.audit_result not null default 'ok',

  trace_id text null,
  payload jsonb not null default '{}'::jsonb
);

-- Append-only enforcement
create or replace function public.audit_events_immutable()
returns trigger language plpgsql as $$
begin
  raise exception 'audit_events is append-only';
end;
$$;

drop trigger if exists trg_audit_events_immutable on public.audit_events;
create trigger trg_audit_events_immutable
before update or delete on public.audit_events
for each row execute function public.audit_events_immutable();

-- Non-forgeable actor/org enforcement on INSERT
create or replace function public.audit_events_guard()
returns trigger language plpgsql as $$
declare
  v_role public.org_role;
begin
  -- Force actor_user_id
  new.actor_user_id := auth.uid();

  -- If org_id provided, actor must belong and role derived
  if new.org_id is not null then
    select uor.role into v_role
    from public.user_org_roles uor
    where uor.user_id = auth.uid()
      and uor.org_id = new.org_id
    limit 1;

    if v_role is null then
      raise exception 'forbidden: actor not in org';
    end if;

    new.actor_role := v_role;
  else
    -- If org_id null, role stays null (allowed only for system/diagnostic uses)
    new.actor_role := null;
  end if;

  -- Surface safety
  if new.surface not in ('founder','primary','public') then
    new.surface := 'primary';
  end if;

  return new;
end;
$$;

drop trigger if exists trg_audit_events_guard on public.audit_events;
create trigger trg_audit_events_guard
before insert on public.audit_events
for each row execute function public.audit_events_guard();

-- =========================
-- 4) RLS + Role helpers
-- =========================

alter table public.orgs enable row level security;
alter table public.user_org_roles enable row level security;
alter table public.offers enable row level security;
alter table public.outbound_sequences enable row level security;
alter table public.outbound_scripts enable row level security;
alter table public.deals enable row level security;
alter table public.deal_objections enable row level security;
alter table public.performance_snapshots enable row level security;
alter table public.operator_tasks enable row level security;
alter table public.audit_events enable row level security;

create or replace function public.current_role(_org_id uuid)
returns public.org_role
language sql stable as $$
  select uor.role
  from public.user_org_roles uor
  where uor.user_id = auth.uid()
    and uor.org_id = _org_id
  limit 1
$$;

create or replace function public.is_founder(_org_id uuid)
returns boolean
language sql stable as $$
  select coalesce(public.current_role(_org_id) = 'founder', false)
$$;

create or replace function public.is_operator(_org_id uuid)
returns boolean
language sql stable as $$
  select coalesce(public.current_role(_org_id) = 'operator', false)
$$;

-- =========================
-- 5) Policies (Core)
-- =========================

-- ORGS: visible only if user has role in org
drop policy if exists orgs_select on public.orgs;
create policy orgs_select on public.orgs
for select using (
  exists (
    select 1 from public.user_org_roles uor
    where uor.user_id = auth.uid()
      and uor.org_id = orgs.id
  )
);

-- ORGS: no client writes (provisioned via admin/founder surface outside RLS scope)
drop policy if exists orgs_write on public.orgs;
create policy orgs_write on public.orgs
for all using (false) with check (false);

-- USER ORG ROLES:
-- - operators can only see their own role row
-- - founders can view membership for their org
drop policy if exists uor_select on public.user_org_roles;
create policy uor_select on public.user_org_roles
for select using (
  user_id = auth.uid()
  or public.is_founder(org_id)
);

drop policy if exists uor_write on public.user_org_roles;
create policy uor_write on public.user_org_roles
for all using (false) with check (false);

-- OFFERS / SEQUENCES / SCRIPTS: founders can do all; operators can draft & edit only when not locked
drop policy if exists offers_select on public.offers;
create policy offers_select on public.offers
for select using (public.is_founder(org_id) or public.is_operator(org_id));

drop policy if exists offers_insert on public.offers;
create policy offers_insert on public.offers
for insert with check (
  public.is_operator(org_id)
  and owner_user_id = auth.uid()
  and status = 'draft'
  and founder_locked = false
);

drop policy if exists offers_update on public.offers;
create policy offers_update on public.offers
for update using (
  public.is_founder(org_id)
  or (
    public.is_operator(org_id)
    and founder_locked = false
    and owner_user_id = auth.uid()
  )
)
with check (
  public.is_founder(org_id)
  or (
    public.is_operator(org_id)
    and founder_locked = false
    and owner_user_id = auth.uid()
  )
);

drop policy if exists seq_select on public.outbound_sequences;
create policy seq_select on public.outbound_sequences
for select using (public.is_founder(org_id) or public.is_operator(org_id));

drop policy if exists seq_insert on public.outbound_sequences;
create policy seq_insert on public.outbound_sequences
for insert with check (public.is_operator(org_id) and status = 'draft' and founder_locked = false);

drop policy if exists seq_update on public.outbound_sequences;
create policy seq_update on public.outbound_sequences
for update using (
  public.is_founder(org_id)
  or (public.is_operator(org_id) and founder_locked = false)
)
with check (
  public.is_founder(org_id)
  or (public.is_operator(org_id) and founder_locked = false)
);

drop policy if exists scripts_select on public.outbound_scripts;
create policy scripts_select on public.outbound_scripts
for select using (public.is_founder(org_id) or public.is_operator(org_id));

drop policy if exists scripts_insert on public.outbound_scripts;
create policy scripts_insert on public.outbound_scripts
for insert with check (public.is_operator(org_id) and founder_locked = false);

drop policy if exists scripts_update on public.outbound_scripts;
create policy scripts_update on public.outbound_scripts
for update using (
  public.is_founder(org_id)
  or (public.is_operator(org_id) and founder_locked = false)
)
with check (
  public.is_founder(org_id)
  or (public.is_operator(org_id) and founder_locked = false)
);

-- DEALS / OBJECTIONS: both founder+operator read/write (execution artifacts)
drop policy if exists deals_select on public.deals;
create policy deals_select on public.deals
for select using (public.is_founder(org_id) or public.is_operator(org_id));

drop policy if exists deals_insert on public.deals;
create policy deals_insert on public.deals
for insert with check (public.is_operator(org_id));

drop policy if exists deals_update on public.deals;
create policy deals_update on public.deals
for update using (public.is_founder(org_id) or public.is_operator(org_id))
with check (public.is_founder(org_id) or public.is_operator(org_id));

drop policy if exists obj_select on public.deal_objections;
create policy obj_select on public.deal_objections
for select using (public.is_founder(org_id) or public.is_operator(org_id));

drop policy if exists obj_insert on public.deal_objections;
create policy obj_insert on public.deal_objections
for insert with check (public.is_operator(org_id));

drop policy if exists obj_update on public.deal_objections;
create policy obj_update on public.deal_objections
for update using (public.is_founder(org_id) or public.is_operator(org_id))
with check (public.is_founder(org_id) or public.is_operator(org_id));

-- PERFORMANCE: operator can insert; founder can update (optional); both can read
drop policy if exists perf_select on public.performance_snapshots;
create policy perf_select on public.performance_snapshots
for select using (public.is_founder(org_id) or public.is_operator(org_id));

drop policy if exists perf_insert on public.performance_snapshots;
create policy perf_insert on public.performance_snapshots
for insert with check (public.is_operator(org_id));

drop policy if exists perf_update on public.performance_snapshots;
create policy perf_update on public.performance_snapshots
for update using (public.is_founder(org_id))
with check (public.is_founder(org_id));

-- OPERATOR TASKS:
-- Read: founder+operator
drop policy if exists tasks_select on public.operator_tasks;
create policy tasks_select on public.operator_tasks
for select using (public.is_founder(org_id) or public.is_operator(org_id));

-- Write: CLOSED from clients. RPC only.
drop policy if exists tasks_write_closed on public.operator_tasks;
create policy tasks_write_closed on public.operator_tasks
for all using (false) with check (false);

-- AUDIT:
-- insert allowed (guard trigger enforces membership); select founder-only
drop policy if exists audit_insert on public.audit_events;
create policy audit_insert on public.audit_events
for insert with check (true);

drop policy if exists audit_select on public.audit_events;
create policy audit_select on public.audit_events
for select using (org_id is not null and public.is_founder(org_id));

-- =========================
-- 6) Indexes (performance)
-- =========================

create index if not exists idx_user_org_roles_user on public.user_org_roles(user_id);
create index if not exists idx_user_org_roles_org on public.user_org_roles(org_id);

create index if not exists idx_offers_org on public.offers(org_id);
create index if not exists idx_sequences_org on public.outbound_sequences(org_id);
create index if not exists idx_scripts_org on public.outbound_scripts(org_id);
create index if not exists idx_deals_org on public.deals(org_id);
create index if not exists idx_objections_org on public.deal_objections(org_id);
create index if not exists idx_perf_org on public.performance_snapshots(org_id);
create index if not exists idx_tasks_org on public.operator_tasks(org_id);
create index if not exists idx_audit_org on public.audit_events(org_id);

commit;
