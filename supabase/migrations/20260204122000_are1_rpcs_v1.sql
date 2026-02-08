-- 20260204122000_are1_rpcs_v1.sql
-- ARE-1 RPC set (the only write-path for tasks; safe metric logging)
-- Uses SECURITY DEFINER to bypass closed client write policies on operator_tasks.
-- All authority checks are performed with invoker identity via auth.uid().

begin;

-- =========================
-- 0) Utility: safe audit append
-- =========================

create or replace function public.rpc_append_audit(
  p_org_id uuid,
  p_surface public.audit_surface,
  p_action text,
  p_target text default null,
  p_result public.audit_result default 'ok',
  p_trace_id text default null,
  p_payload jsonb default '{}'::jsonb
)
returns void
language plpgsql
security definer
set search_path = public, auth
as $$
begin
  insert into public.audit_events(org_id, surface, action, target, result, trace_id, payload)
  values (
    p_org_id,
    coalesce(p_surface, 'primary'),
    p_action,
    p_target,
    coalesce(p_result, 'ok'),
    p_trace_id,
    coalesce(p_payload, '{}'::jsonb)
  );
end;
$$;

grant execute on function public.rpc_append_audit(uuid, public.audit_surface, text, text, public.audit_result, text, jsonb) to authenticated;

-- =========================
-- 1) Issue Task (Founder-only)
-- =========================

create or replace function public.rpc_issue_task(
  p_org_id uuid,
  p_task_type public.task_type,
  p_title text,
  p_directive text,
  p_due_at timestamptz default null,
  p_founder_locked boolean default true,
  p_surface public.audit_surface default 'founder',
  p_trace_id text default null
)
returns uuid
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_task_id uuid;
begin
  if not public.is_founder(p_org_id) then
    raise exception 'forbidden: founder role required';
  end if;

  insert into public.operator_tasks(
    org_id, issuer_user_id, task_type, title, directive, status, due_at, founder_locked
  )
  values(
    p_org_id, auth.uid(), p_task_type, p_title, p_directive, 'open', p_due_at, coalesce(p_founder_locked, true)
  )
  returning id into v_task_id;

  perform public.rpc_append_audit(
    p_org_id,
    p_surface,
    'TASK_ISSUED',
    'operator_tasks:' || v_task_id::text,
    'ok',
    p_trace_id,
    jsonb_build_object(
      'task_type', p_task_type,
      'founder_locked', coalesce(p_founder_locked, true),
      'due_at', p_due_at
    )
  );

  return v_task_id;
end;
$$;

grant execute on function public.rpc_issue_task(uuid, public.task_type, text, text, timestamptz, boolean, public.audit_surface, text) to authenticated;

-- =========================
-- 2) Issue Task From Template (Founder-only)
-- =========================

create or replace function public.rpc_issue_task_from_template(
  p_org_id uuid,
  p_template_id uuid,
  p_due_at timestamptz default null,
  p_surface public.audit_surface default 'founder',
  p_trace_id text default null
)
returns uuid
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_task_id uuid;
  v task_templates%rowtype;
  v_due timestamptz;
begin
  if not public.is_founder(p_org_id) then
    raise exception 'forbidden: founder role required';
  end if;

  select * into v
  from public.task_templates
  where id = p_template_id
    and org_id = p_org_id
    and status = 'active'
  limit 1;

  if not found then
    raise exception 'template not found or not permitted';
  end if;

  if p_due_at is not null then
    v_due := p_due_at;
  elsif v.default_due_hours is not null then
    v_due := now() + make_interval(hours => v.default_due_hours);
  else
    v_due := null;
  end if;

  v_task_id := public.rpc_issue_task(
    p_org_id,
    v.task_type,
    v.title,
    v.directive,
    v_due,
    v.founder_locked,
    p_surface,
    p_trace_id
  );

  return v_task_id;
end;
$$;

grant execute on function public.rpc_issue_task_from_template(uuid, uuid, timestamptz, public.audit_surface, text) to authenticated;

-- =========================
-- 3) Operator: set task status (Operator-only; constrained)
-- =========================

create or replace function public.rpc_task_set_status(
  p_task_id uuid,
  p_status public.task_status,
  p_result_note text default null,
  p_surface public.audit_surface default 'primary',
  p_trace_id text default null
)
returns void
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_org uuid;
  v_locked boolean;
begin
  select org_id, founder_locked into v_org, v_locked
  from public.operator_tasks
  where id = p_task_id
  limit 1;

  if v_org is null then
    raise exception 'task not found';
  end if;

  -- Must be operator in this org
  if not public.is_operator(v_org) then
    raise exception 'forbidden: operator role required';
  end if;

  -- If founder locked, operator may still mark done (execution completion),
  -- but cannot cancel it.
  if v_locked = true and p_status = 'cancelled' then
    raise exception 'forbidden: cannot cancel founder-locked task';
  end if;

  update public.operator_tasks
  set
    status = p_status,
    completed_at = case when p_status = 'done' then now() else completed_at end,
    result_note = coalesce(p_result_note, result_note)
  where id = p_task_id;

  perform public.rpc_append_audit(
    v_org,
    p_surface,
    'TASK_STATUS_SET',
    'operator_tasks:' || p_task_id::text,
    'ok',
    p_trace_id,
    jsonb_build_object(
      'status', p_status,
      'founder_locked', v_locked
    )
  );
end;
$$;

grant execute on function public.rpc_task_set_status(uuid, public.task_status, text, public.audit_surface, text) to authenticated;

-- =========================
-- 4) Operator: log performance snapshot (Operator-only)
-- =========================

create or replace function public.rpc_log_performance_snapshot(
  p_org_id uuid,
  p_period_start date,
  p_period_end date,
  p_outreaches integer default 0,
  p_replies integer default 0,
  p_booked integer default 0,
  p_closes integer default 0,
  p_revenue_cents integer default 0,
  p_failure_flags jsonb default '{}'::jsonb,
  p_surface public.audit_surface default 'primary',
  p_trace_id text default null
)
returns uuid
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  v_id uuid;
begin
  if not public.is_operator(p_org_id) and not public.is_founder(p_org_id) then
    raise exception 'forbidden: org access required';
  end if;

  insert into public.performance_snapshots(
    org_id, period_start, period_end,
    outreaches, replies, booked, closes, revenue_cents,
    failure_flags
  )
  values(
    p_org_id, p_period_start, p_period_end,
    greatest(coalesce(p_outreaches,0),0),
    greatest(coalesce(p_replies,0),0),
    greatest(coalesce(p_booked,0),0),
    greatest(coalesce(p_closes,0),0),
    greatest(coalesce(p_revenue_cents,0),0),
    coalesce(p_failure_flags,'{}'::jsonb)
  )
  returning id into v_id;

  perform public.rpc_append_audit(
    p_org_id,
    p_surface,
    'PERF_SNAPSHOT_LOGGED',
    'performance_snapshots:' || v_id::text,
    'ok',
    p_trace_id,
    jsonb_build_object(
      'period_start', p_period_start,
      'period_end', p_period_end
    )
  );

  return v_id;
end;
$$;

grant execute on function public.rpc_log_performance_snapshot(uuid, date, date, integer, integer, integer, integer, integer, jsonb, public.audit_surface, text) to authenticated;

commit;
