


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS "public";


ALTER SCHEMA "public" OWNER TO "pg_database_owner";


COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE TYPE "public"."action_status" AS ENUM (
    'proposed',
    'approved',
    'rejected',
    'executed'
);


ALTER TYPE "public"."action_status" OWNER TO "postgres";


CREATE TYPE "public"."action_type" AS ENUM (
    'plan_generate',
    'web_publish',
    'outreach_draft',
    'data_change'
);


ALTER TYPE "public"."action_type" OWNER TO "postgres";


CREATE TYPE "public"."actor_enum" AS ENUM (
    'user',
    'agent',
    'system'
);


ALTER TYPE "public"."actor_enum" OWNER TO "postgres";


CREATE TYPE "public"."actor_kind" AS ENUM (
    'human',
    'ai',
    'system'
);


ALTER TYPE "public"."actor_kind" OWNER TO "postgres";


CREATE TYPE "public"."artifact_type" AS ENUM (
    'report',
    'link',
    'file',
    'receipt'
);


ALTER TYPE "public"."artifact_type" OWNER TO "postgres";


CREATE TYPE "public"."asset_status" AS ENUM (
    'draft',
    'active',
    'archived'
);


ALTER TYPE "public"."asset_status" OWNER TO "postgres";


CREATE TYPE "public"."audit_result" AS ENUM (
    'ok',
    'blocked',
    'error'
);


ALTER TYPE "public"."audit_result" OWNER TO "postgres";


CREATE TYPE "public"."audit_surface" AS ENUM (
    'founder',
    'primary',
    'public'
);


ALTER TYPE "public"."audit_surface" OWNER TO "postgres";


CREATE TYPE "public"."confidence_level" AS ENUM (
    'low',
    'medium',
    'high'
);


ALTER TYPE "public"."confidence_level" OWNER TO "postgres";


CREATE TYPE "public"."deal_stage" AS ENUM (
    'new',
    'qualified',
    'proposal',
    'negotiation',
    'closed_won',
    'closed_lost'
);


ALTER TYPE "public"."deal_stage" OWNER TO "postgres";


CREATE TYPE "public"."execution_status" AS ENUM (
    'queued',
    'running',
    'succeeded',
    'failed',
    'reverted'
);


ALTER TYPE "public"."execution_status" OWNER TO "postgres";


CREATE TYPE "public"."execution_status_enum" AS ENUM (
    'pending',
    'running',
    'completed',
    'failed',
    'reversed'
);


ALTER TYPE "public"."execution_status_enum" OWNER TO "postgres";


CREATE TYPE "public"."intent_status" AS ENUM (
    'draft',
    'submitted',
    'blocked',
    'approved',
    'rejected',
    'executed',
    'reverted'
);


ALTER TYPE "public"."intent_status" OWNER TO "postgres";


CREATE TYPE "public"."member_role" AS ENUM (
    'owner',
    'admin',
    'member'
);


ALTER TYPE "public"."member_role" OWNER TO "postgres";


CREATE TYPE "public"."org_role" AS ENUM (
    'founder',
    'operator'
);


ALTER TYPE "public"."org_role" OWNER TO "postgres";


CREATE TYPE "public"."org_status" AS ENUM (
    'active',
    'suspended',
    'closed'
);


ALTER TYPE "public"."org_status" OWNER TO "postgres";


CREATE TYPE "public"."plan_tier" AS ENUM (
    'tier1',
    'tier2a',
    'tier2b',
    'tier3'
);


ALTER TYPE "public"."plan_tier" OWNER TO "postgres";


CREATE TYPE "public"."profile_role" AS ENUM (
    'founder',
    'operator',
    'subscriber'
);


ALTER TYPE "public"."profile_role" OWNER TO "postgres";


CREATE TYPE "public"."proposal_status" AS ENUM (
    'PENDING_APPROVAL',
    'APPROVED',
    'REJECTED',
    'EXPIRED',
    'EXECUTED'
);


ALTER TYPE "public"."proposal_status" OWNER TO "postgres";


CREATE TYPE "public"."risk_level" AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH'
);


ALTER TYPE "public"."risk_level" OWNER TO "postgres";


CREATE TYPE "public"."run_status" AS ENUM (
    'draft',
    'awaiting_approval',
    'executing',
    'completed',
    'rejected'
);


ALTER TYPE "public"."run_status" OWNER TO "postgres";


CREATE TYPE "public"."script_status" AS ENUM (
    'active',
    'archived'
);


ALTER TYPE "public"."script_status" OWNER TO "postgres";


CREATE TYPE "public"."script_type" AS ENUM (
    'opening',
    'followup',
    'objection',
    'closing',
    'voicemail',
    'dm'
);


ALTER TYPE "public"."script_type" OWNER TO "postgres";


CREATE TYPE "public"."sensitivity_enum" AS ENUM (
    'low',
    'medium',
    'high',
    'do_not_store'
);


ALTER TYPE "public"."sensitivity_enum" OWNER TO "postgres";


CREATE TYPE "public"."sensitivity_level" AS ENUM (
    'public',
    'internal',
    'founder_confidential',
    'do_not_store'
);


ALTER TYPE "public"."sensitivity_level" OWNER TO "postgres";


CREATE TYPE "public"."sequence_channel" AS ENUM (
    'email',
    'sms',
    'social',
    'phone',
    'multi'
);


ALTER TYPE "public"."sequence_channel" OWNER TO "postgres";


CREATE TYPE "public"."sequence_status" AS ENUM (
    'draft',
    'active',
    'paused',
    'archived'
);


ALTER TYPE "public"."sequence_status" OWNER TO "postgres";


CREATE TYPE "public"."source_type" AS ENUM (
    'decision_memo',
    'pattern'
);


ALTER TYPE "public"."source_type" OWNER TO "postgres";


CREATE TYPE "public"."task_status" AS ENUM (
    'open',
    'in_progress',
    'blocked',
    'done',
    'cancelled'
);


ALTER TYPE "public"."task_status" OWNER TO "postgres";


CREATE TYPE "public"."task_type" AS ENUM (
    'offer_refine',
    'send_outbound',
    'follow_up',
    'deal_update',
    'review_script',
    'report_metrics'
);


ALTER TYPE "public"."task_type" OWNER TO "postgres";


CREATE TYPE "public"."tenant_status" AS ENUM (
    'active',
    'past_due',
    'canceled'
);


ALTER TYPE "public"."tenant_status" OWNER TO "postgres";


CREATE TYPE "public"."verdict_enum" AS ENUM (
    'approved',
    'rejected',
    'abstained'
);


ALTER TYPE "public"."verdict_enum" OWNER TO "postgres";


CREATE TYPE "public"."verdict_type" AS ENUM (
    'approve',
    'revise',
    'reject',
    'defer'
);


ALTER TYPE "public"."verdict_type" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."approve_run_action"("p_action_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
declare
  v_run_id uuid;
  v_tenant_id uuid;
begin
  select ra.run_id into v_run_id
  from public.run_actions ra
  where ra.id = p_action_id;

  if v_run_id is null then
    raise exception 'Action not found';
  end if;

  select r.tenant_id into v_tenant_id
  from public.runs r
  where r.id = v_run_id;

  if not public.is_member_of_tenant(v_tenant_id) then
    raise exception 'Not authorized';
  end if;

  -- Kill switch check (founder global kill switch); if you want it to stop all approvals:
  if exists (
    select 1 from founder.kill_switch ks
    where ks.id = true and ks.is_enabled = false
  ) then
    raise exception 'System is disabled by kill switch';
  end if;

  update public.run_actions
  set status = 'approved'::action_status,
      approved_by = auth.uid(),
      approved_at = now()
  where id = p_action_id
    and status = 'proposed'::action_status;
end;
$$;


ALTER FUNCTION "public"."approve_run_action"("p_action_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."are1_issue_directive"("p_operator_id" "uuid", "p_intake_id" "uuid", "p_issued_actions" integer, "p_due_by" "date") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  v_enabled boolean;
  v_ok boolean;
  v_id uuid;
BEGIN
  -- Gate 1: Kill switch
  SELECT enabled INTO v_enabled
  FROM are1_kill_switch
  WHERE scope = 'ARE-1';

  IF v_enabled IS DISTINCT FROM true THEN
    RAISE EXCEPTION 'ARE-1 disabled (kill switch)';
  END IF;

  -- Gate 2: Intake must belong to operator and be approved/locked
  SELECT TRUE INTO v_ok
  FROM are1_operator_intake i
  WHERE i.id = p_intake_id
    AND i.operator_id = p_operator_id
    AND i.status IN ('approved','locked');

  IF v_ok IS DISTINCT FROM true THEN
    RAISE EXCEPTION 'invalid intake for directive issuance';
  END IF;

  INSERT INTO are1_directives (operator_id, intake_id, issued_actions, due_by, created_by)
  VALUES (p_operator_id, p_intake_id, p_issued_actions, p_due_by, auth.uid())
  ON CONFLICT (operator_id, due_by)
  DO UPDATE SET
    intake_id = EXCLUDED.intake_id,
    issued_actions = EXCLUDED.issued_actions,
    status = 'issued',
    created_at = now(),
    created_by = EXCLUDED.created_by
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;


ALTER FUNCTION "public"."are1_issue_directive"("p_operator_id" "uuid", "p_intake_id" "uuid", "p_issued_actions" integer, "p_due_by" "date") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."are1_upsert_compliance_score"("p_operator_id" "uuid", "p_intake_id" "uuid", "p_issued_actions" integer, "p_completed_actions" integer) RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  v_enabled boolean;
  v_score numeric(5,2);
  v_id uuid;
BEGIN
  -- Gate 1: Kill switch must be enabled
  SELECT enabled INTO v_enabled
  FROM are1_kill_switch
  WHERE scope = 'ARE-1';

  IF v_enabled IS DISTINCT FROM true THEN
    RAISE EXCEPTION 'ARE-1 disabled (kill switch)';
  END IF;

  IF p_issued_actions < 0 OR p_completed_actions < 0 THEN
    RAISE EXCEPTION 'invalid action counts';
  END IF;

  IF p_completed_actions > p_issued_actions THEN
    RAISE EXCEPTION 'completed_actions cannot exceed issued_actions';
  END IF;

  IF p_issued_actions = 0 THEN
    v_score := 0;
  ELSE
    v_score := round((p_completed_actions::numeric / p_issued_actions::numeric) * 100, 2);
  END IF;

  INSERT INTO are1_compliance_scores (
    operator_id, intake_id, issued_actions, completed_actions, compliance_score
  )
  VALUES (
    p_operator_id, p_intake_id, p_issued_actions, p_completed_actions, v_score
  )
  ON CONFLICT (operator_id, intake_id)
  DO UPDATE SET
    issued_actions = EXCLUDED.issued_actions,
    completed_actions = EXCLUDED.completed_actions,
    compliance_score = EXCLUDED.compliance_score,
    calculated_at = now()
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;


ALTER FUNCTION "public"."are1_upsert_compliance_score"("p_operator_id" "uuid", "p_intake_id" "uuid", "p_issued_actions" integer, "p_completed_actions" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."audit_events_guard"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
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


ALTER FUNCTION "public"."audit_events_guard"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."audit_events_immutable"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  raise exception 'audit_events is append-only';
end;
$$;


ALTER FUNCTION "public"."audit_events_immutable"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."current_role"("_org_id" "uuid") RETURNS "public"."org_role"
    LANGUAGE "sql" STABLE
    AS $$
  select uor.role
  from public.user_org_roles uor
  where uor.user_id = auth.uid()
    and uor.org_id = _org_id
  limit 1
$$;


ALTER FUNCTION "public"."current_role"("_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."enforce_no_action_rationale"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  if new.completed_outcome = 'no_action_taken' and (new.no_action_rationale is null or length(trim(new.no_action_rationale)) = 0) then
    raise exception 'no_action_rationale required when completed_outcome = no_action_taken';
  end if;
  return new;
end;
$$;


ALTER FUNCTION "public"."enforce_no_action_rationale"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."execute_approved_founder_state_change"("p_tenant_id" "uuid", "p_proposal_id" "uuid", "p_founder_state_id" "uuid", "p_patch" "jsonb") RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'pg_catalog', 'public', 'founder'
    AS $$
declare
  v_approval_id uuid;
  v_before jsonb;
  v_after jsonb;
  v_execution_id uuid;

  v_now timestamptz := now();
  v_kill_enabled boolean;
  v_elim_status text;

  v_canonical_patch jsonb;
  v_payload jsonb;

  v_set jsonb;
  v_state_patch jsonb;
begin
  -- KILL SWITCH GATE
  select coalesce(ks.enabled, false) into v_kill_enabled
  from public.kill_switch ks
  limit 1;

  if v_kill_enabled then
    raise exception 'KILL_SWITCH_ENABLED' using errcode = 'P0001';
  end if;

  -- ELIMINATION REGISTRY GATE
  select er.status into v_elim_status
  from ak_governance.elimination_registry er
  where er.schema_name = 'public'
    and er.object_name = 'execute_approved_founder_state_change'
  order by er.updated_at desc
  limit 1;

  if v_elim_status = 'NON_ACTIONABLE' then
    raise exception 'ELIMINATION_NON_ACTIONABLE' using errcode = 'P0001';
  end if;

  -- Proposal must exist + load canonical patch (single source of truth)
  select p.patch, p.payload
    into v_canonical_patch, v_payload
  from public.proposals p
  where p.id = p_proposal_id
    and p.tenant_id = p_tenant_id
  limit 1;

  if not found then
    raise exception 'PROPOSAL_NOT_FOUND' using errcode = 'P0001';
  end if;

  if v_canonical_patch is null then
    v_canonical_patch := v_payload->'patch';
  end if;

  if v_canonical_patch is null then
    raise exception 'PROPOSAL_PATCH_MISSING' using errcode = 'P0001';
  end if;

  -- Normalize legacy patch bodies by wrapping them in { set: ... }
  if jsonb_typeof(v_canonical_patch) = 'object' and not (v_canonical_patch ? 'set') then
    v_canonical_patch := jsonb_build_object('set', v_canonical_patch);
  end if;

  -- Optional guard: if caller supplies p_patch, it must match the proposal's patch
  if p_patch is not null and p_patch <> v_canonical_patch then
    raise exception 'PATCH_MISMATCH_CALLER_VS_PROPOSAL' using errcode = 'P0001';
  end if;

  -- Approval must be valid
  select a.id into v_approval_id
  from public.approvals a
  where a.tenant_id = p_tenant_id
    and a.proposal_id = p_proposal_id
    and a.decision = 'APPROVE'
    and (a.expires_at is null or a.expires_at > v_now)
    and a.consumed_at is null
  order by a.created_at desc nulls last
  limit 1;

  if v_approval_id is null then
    raise exception 'APPROVAL_REQUIRED_OR_INVALID' using errcode = 'P0001';
  end if;

  -- Parse canonical patch ONLY
  v_set := coalesce(v_canonical_patch->'set', '{}'::jsonb);
  if jsonb_typeof(v_set) is distinct from 'object' then
    raise exception 'PATCH_INVALID_SET_OBJECT' using errcode = 'P0001';
  end if;

  -- Lock founder_state
  select to_jsonb(fs) into v_before
  from public.founder_state fs
  where fs.id = p_founder_state_id
  for update;

  if v_before is null then
    raise exception 'FOUNDER_STATE_NOT_FOUND' using errcode = 'P0001';
  end if;

  -- Apply patch to state JSON (merge object)
  v_state_patch := v_set->'state';

  update public.founder_state fs
  set
    mode = coalesce((v_set->>'mode')::text, fs.mode),
    phase = coalesce((v_set->>'phase')::text, fs.phase),
    next_action = coalesce((v_set->>'next_action')::text, fs.next_action),
    state = case
      when v_state_patch is null then fs.state
      when jsonb_typeof(v_state_patch) <> 'object' then fs.state
      else fs.state || v_state_patch
    end,
    operational_mode = coalesce((v_set->>'operational_mode')::text,
                                coalesce((v_set->>'mode')::text, fs.operational_mode)),
    last_change_at = v_now,
    last_updated = v_now
  where fs.id = p_founder_state_id;

  select to_jsonb(fs) into v_after
  from public.founder_state fs
  where fs.id = p_founder_state_id;

  -- Record execution with CANONICAL patch (receipt integrity)
  insert into public.executions (
    proposal_id, status, executor_name, before_row, after_row, applied_patch, started_at, finished_at
  )
  values (
    p_proposal_id, 'succeeded', 'ControlledExecutor', v_before, v_after, v_canonical_patch, v_now, v_now
  )
  returning id into v_execution_id;

  update public.founder_state
  set last_change_execution_id = v_execution_id
  where id = p_founder_state_id;

  -- Consume approval (replay prevention)
  update public.approvals
  set consumed_at = v_now
  where id = v_approval_id;

  insert into public.audit_ledger (
    event_type, actor, actor_user_id, actor_agent_name, proposal_id, execution_id, details
  )
  values (
    'EXECUTION_SUCCEEDED',
    'system',
    null,
    'ControlledExecutor',
    p_proposal_id,
    v_execution_id,
    jsonb_build_object(
      'tenant_id', p_tenant_id,
      'approval_id', v_approval_id,
      'founder_state_id', p_founder_state_id,
      'patch', v_canonical_patch
    )
  );

  return jsonb_build_object(
    'ok', true,
    'tenant_id', p_tenant_id,
    'proposal_id', p_proposal_id,
    'approval_id', v_approval_id,
    'execution_id', v_execution_id,
    'before', v_before,
    'after', v_after,
    'applied_patch', v_canonical_patch
  );
end;
$$;


ALTER FUNCTION "public"."execute_approved_founder_state_change"("p_tenant_id" "uuid", "p_proposal_id" "uuid", "p_founder_state_id" "uuid", "p_patch" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
                                                                                                                                                                  begin
                                                                                                                                                                    insert into public.profiles (id, email, role)
                                                                                                                                                                      values (new.id, new.email, 'subscriber')
                                                                                                                                                                        on conflict (id) do update set email = excluded.email;
                                                                                                                                                                          return new;
                                                                                                                                                                          end;
                                                                                                                                                                          $$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_founder"() RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public', 'ak', 'founder', 'auth', 'pg_temp'
    AS $$
  select coalesce(founder.is_active_founder(auth.uid()), false);
$$;


ALTER FUNCTION "public"."is_founder"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_founder"("_org_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE
    AS $$
  select coalesce(public.current_role(_org_id) = 'founder', false)
$$;


ALTER FUNCTION "public"."is_founder"("_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_founder_debug"("user_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE
    AS $$
  select exists (
    select 1
    from public.founder_profile fp
    where fp.founder_id = user_id
      and fp.is_active = true
  );
$$;


ALTER FUNCTION "public"."is_founder_debug"("user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_member_of_tenant"("tid" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE
    SET "search_path" TO 'public'
    AS $$
                                                                                                                                                                            select exists (
                                                                                                                                                                                select 1
                                                                                                                                                                                    from public.tenant_members tm
                                                                                                                                                                                        where tm.tenant_id = tid
                                                                                                                                                                                              and tm.user_id = auth.uid()
                                                                                                                                                                                                );
                                                                                                                                                                                                $$;


ALTER FUNCTION "public"."is_member_of_tenant"("tid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_operator"("_org_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE
    AS $$
  select coalesce(public.current_role(_org_id) = 'operator', false)
$$;


ALTER FUNCTION "public"."is_operator"("_org_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_row_owner"("row_user_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE
    AS $$
  select auth.uid() = row_user_id
  $$;


ALTER FUNCTION "public"."is_row_owner"("row_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_thread_owner"("thread_uuid" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE
    AS $$
  select exists (
      select 1
          from public.threads t
              where t.id = thread_uuid
                    and t.created_by = auth.uid()
                      );
                      $$;


ALTER FUNCTION "public"."is_thread_owner"("thread_uuid" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."kdh_check_rate_limit"("max_requests" integer, "window_seconds" integer) RETURNS "jsonb"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
declare
  uid uuid := auth.uid();
  now_ts timestamptz := now();
  wstart timestamptz := date_trunc('second', now_ts) - make_interval(secs => (extract(epoch from date_trunc('second', now_ts))::int % window_seconds));
  current_count integer;
begin
  if uid is null then
    return jsonb_build_object('ok', false, 'status', 401, 'error', 'Unauthorized');
  end if;

  insert into public.kdh_rate_limits(user_id, window_start, count)
  values (uid, wstart, 1)
  on conflict (user_id, window_start)
  do update set count = public.kdh_rate_limits.count + 1
  returning count into current_count;

  if current_count > max_requests then
    return jsonb_build_object('ok', false, 'status', 429, 'error', 'Rate limit exceeded', 'count', current_count, 'window_start', wstart);
  end if;

  return jsonb_build_object('ok', true, 'status', 200, 'count', current_count, 'window_start', wstart);
end;
$$;


ALTER FUNCTION "public"."kdh_check_rate_limit"("max_requests" integer, "window_seconds" integer) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."normalize_approval_decision"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.decision := upper(new.decision);
    return new;
    end;
    $$;


ALTER FUNCTION "public"."normalize_approval_decision"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."prevent_health_checks_delete"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  raise exception 'health_checks is a singleton and cannot be deleted';
end;
$$;


ALTER FUNCTION "public"."prevent_health_checks_delete"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rpc_append_audit"("p_org_id" "uuid", "p_surface" "public"."audit_surface", "p_action" "text", "p_target" "text" DEFAULT NULL::"text", "p_result" "public"."audit_result" DEFAULT 'ok'::"public"."audit_result", "p_trace_id" "text" DEFAULT NULL::"text", "p_payload" "jsonb" DEFAULT '{}'::"jsonb") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'auth'
    AS $$
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


ALTER FUNCTION "public"."rpc_append_audit"("p_org_id" "uuid", "p_surface" "public"."audit_surface", "p_action" "text", "p_target" "text", "p_result" "public"."audit_result", "p_trace_id" "text", "p_payload" "jsonb") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rpc_issue_task"("p_org_id" "uuid", "p_task_type" "public"."task_type", "p_title" "text", "p_directive" "text", "p_due_at" timestamp with time zone DEFAULT NULL::timestamp with time zone, "p_founder_locked" boolean DEFAULT true, "p_surface" "public"."audit_surface" DEFAULT 'founder'::"public"."audit_surface", "p_trace_id" "text" DEFAULT NULL::"text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'auth'
    AS $$
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


ALTER FUNCTION "public"."rpc_issue_task"("p_org_id" "uuid", "p_task_type" "public"."task_type", "p_title" "text", "p_directive" "text", "p_due_at" timestamp with time zone, "p_founder_locked" boolean, "p_surface" "public"."audit_surface", "p_trace_id" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rpc_issue_task_from_template"("p_org_id" "uuid", "p_template_id" "uuid", "p_due_at" timestamp with time zone DEFAULT NULL::timestamp with time zone, "p_surface" "public"."audit_surface" DEFAULT 'founder'::"public"."audit_surface", "p_trace_id" "text" DEFAULT NULL::"text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'auth'
    AS $$
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


ALTER FUNCTION "public"."rpc_issue_task_from_template"("p_org_id" "uuid", "p_template_id" "uuid", "p_due_at" timestamp with time zone, "p_surface" "public"."audit_surface", "p_trace_id" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rpc_log_performance_snapshot"("p_org_id" "uuid", "p_period_start" "date", "p_period_end" "date", "p_outreaches" integer DEFAULT 0, "p_replies" integer DEFAULT 0, "p_booked" integer DEFAULT 0, "p_closes" integer DEFAULT 0, "p_revenue_cents" integer DEFAULT 0, "p_failure_flags" "jsonb" DEFAULT '{}'::"jsonb", "p_surface" "public"."audit_surface" DEFAULT 'primary'::"public"."audit_surface", "p_trace_id" "text" DEFAULT NULL::"text") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'auth'
    AS $$
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


ALTER FUNCTION "public"."rpc_log_performance_snapshot"("p_org_id" "uuid", "p_period_start" "date", "p_period_end" "date", "p_outreaches" integer, "p_replies" integer, "p_booked" integer, "p_closes" integer, "p_revenue_cents" integer, "p_failure_flags" "jsonb", "p_surface" "public"."audit_surface", "p_trace_id" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."rpc_task_set_status"("p_task_id" "uuid", "p_status" "public"."task_status", "p_result_note" "text" DEFAULT NULL::"text", "p_surface" "public"."audit_surface" DEFAULT 'primary'::"public"."audit_surface", "p_trace_id" "text" DEFAULT NULL::"text") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public', 'auth'
    AS $$
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


ALTER FUNCTION "public"."rpc_task_set_status"("p_task_id" "uuid", "p_status" "public"."task_status", "p_result_note" "text", "p_surface" "public"."audit_surface", "p_trace_id" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_created_by"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
begin
  if new.created_by is null then
      new.created_by := auth.uid();
        end if;
          return new;
          end;
          $$;


ALTER FUNCTION "public"."set_created_by"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


ALTER FUNCTION "public"."set_updated_at"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."tenant_id_from_stripe"("p_customer_id" "text", "p_subscription_id" "text") RETURNS "uuid"
    LANGUAGE "sql" STABLE
    AS $$
  select id
  from public.tenants
  where (p_customer_id is not null and stripe_customer_id = p_customer_id)
     or (p_subscription_id is not null and stripe_subscription_id = p_subscription_id)
  limit 1
$$;


ALTER FUNCTION "public"."tenant_id_from_stripe"("p_customer_id" "text", "p_subscription_id" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."touch_updated_at"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.updated_at = now();
  return new;
end $$;


ALTER FUNCTION "public"."touch_updated_at"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."audit_ledger" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "event_type" "text" NOT NULL,
    "actor" "public"."actor_kind" NOT NULL,
    "actor_user_id" "uuid",
    "actor_agent_name" "text",
    "intent_id" "uuid",
    "proposal_id" "uuid",
    "execution_id" "uuid",
    "details" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."audit_ledger" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tenants" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "plan" "public"."plan_tier" NOT NULL,
    "stripe_customer_id" "text",
    "stripe_subscription_id" "text",
    "status" "public"."tenant_status" DEFAULT 'active'::"public"."tenant_status" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "raw_output_visibility" "text" DEFAULT 'hidden_by_default'::"text" NOT NULL,
    "learning_opt_in" boolean DEFAULT false NOT NULL,
    CONSTRAINT "tenants_raw_output_visibility_check" CHECK (("raw_output_visibility" = ANY (ARRAY['hidden_by_default'::"text", 'allow_opt_in'::"text"])))
);


ALTER TABLE "public"."tenants" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tool_audit_log" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "run_id" "uuid",
    "proposal_id" "uuid",
    "approval_id" "uuid",
    "tool_name" "text" NOT NULL,
    "status" "text" NOT NULL,
    "input" "jsonb",
    "output" "jsonb",
    "error" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."tool_audit_log" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."approvals" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "proposal_id" "uuid" NOT NULL,
    "approved_by" "uuid",
    "decision" "text" NOT NULL,
    "notes" "text",
    "approval_token_hash" "text",
    "expires_at" timestamp with time zone,
    "consumed_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"(),
    CONSTRAINT "approvals_approve_requires_approved_by" CHECK ((("decision" <> 'APPROVE'::"text") OR ("approved_by" IS NOT NULL))),
    CONSTRAINT "approvals_consumed_not_after_expiry" CHECK ((("consumed_at" IS NULL) OR ("expires_at" IS NULL) OR ("consumed_at" <= "expires_at"))),
    CONSTRAINT "approvals_consumed_requires_approve" CHECK ((("consumed_at" IS NULL) OR ("decision" = 'APPROVE'::"text"))),
    CONSTRAINT "approvals_consumed_requires_token" CHECK ((("consumed_at" IS NULL) OR ("approval_token_hash" IS NOT NULL))),
    CONSTRAINT "approvals_decision_check" CHECK (("decision" = ANY (ARRAY['APPROVE'::"text", 'REJECT'::"text"]))),
    CONSTRAINT "approvals_valid_decision" CHECK (("decision" = ANY (ARRAY['APPROVE'::"text", 'REJECT'::"text", 'REVOKE'::"text"])))
);


ALTER TABLE "public"."approvals" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."ak_cockpit_override_state" (
    "session_id" "text" NOT NULL,
    "enabled" boolean DEFAULT false NOT NULL,
    "mode" "text" DEFAULT 'force_action'::"text" NOT NULL,
    "reason" "text",
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."ak_cockpit_override_state" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."are1_compliance_scores" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "operator_id" "uuid" NOT NULL,
    "intake_id" "uuid" NOT NULL,
    "issued_actions" integer NOT NULL,
    "completed_actions" integer NOT NULL,
    "compliance_score" numeric(5,2) NOT NULL,
    "calculated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "are1_compliance_scores_completed_actions_check" CHECK (("completed_actions" >= 0)),
    CONSTRAINT "are1_compliance_scores_compliance_score_check" CHECK ((("compliance_score" >= (0)::numeric) AND ("compliance_score" <= (100)::numeric))),
    CONSTRAINT "are1_compliance_scores_issued_actions_check" CHECK (("issued_actions" >= 0))
);


ALTER TABLE "public"."are1_compliance_scores" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."are1_directives" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "operator_id" "uuid" NOT NULL,
    "intake_id" "uuid" NOT NULL,
    "issued_actions" integer NOT NULL,
    "due_by" "date" NOT NULL,
    "status" "text" DEFAULT 'issued'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_by" "uuid",
    CONSTRAINT "are1_directives_issued_actions_check" CHECK (("issued_actions" > 0)),
    CONSTRAINT "are1_directives_status_check" CHECK (("status" = ANY (ARRAY['issued'::"text", 'completed'::"text", 'void'::"text"])))
);


ALTER TABLE "public"."are1_directives" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."are1_kill_switch" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "scope" "text" DEFAULT 'ARE-1'::"text" NOT NULL,
    "enabled" boolean DEFAULT true NOT NULL,
    "reason" "text",
    "updated_by" "uuid",
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "are1_kill_switch_scope_check" CHECK (("scope" = 'ARE-1'::"text"))
);


ALTER TABLE "public"."are1_kill_switch" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."are1_operator_intake" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "operator_id" "uuid" NOT NULL,
    "submitted_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "service_description" "text" NOT NULL,
    "target_buyer" "text" NOT NULL,
    "price_cents" integer NOT NULL,
    "outreach_channel" "text" NOT NULL,
    "last_7_day_action_count" integer NOT NULL,
    "status" "text" DEFAULT 'pending'::"text" NOT NULL,
    "approved_at" timestamp with time zone,
    "locked_at" timestamp with time zone,
    CONSTRAINT "are1_operator_intake_last_7_day_action_count_check" CHECK (("last_7_day_action_count" >= 0)),
    CONSTRAINT "are1_operator_intake_outreach_channel_check" CHECK (("outreach_channel" = ANY (ARRAY['cold_call'::"text", 'sms'::"text", 'email'::"text", 'dm'::"text"]))),
    CONSTRAINT "are1_operator_intake_price_cents_check" CHECK (("price_cents" > 0)),
    CONSTRAINT "are1_operator_intake_service_description_check" CHECK ((("length"("service_description") >= 20) AND ("length"("service_description") <= 300))),
    CONSTRAINT "are1_operator_intake_status_check" CHECK (("status" = ANY (ARRAY['pending'::"text", 'approved'::"text", 'rejected'::"text", 'locked'::"text"]))),
    CONSTRAINT "are1_operator_intake_target_buyer_check" CHECK ((("length"("target_buyer") >= 10) AND ("length"("target_buyer") <= 200)))
);


ALTER TABLE "public"."are1_operator_intake" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."audit_events" (
    "event_id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "ts" timestamp with time zone DEFAULT "now"() NOT NULL,
    "org_id" "uuid",
    "actor_user_id" "uuid",
    "actor_role" "public"."org_role",
    "surface" "public"."audit_surface" DEFAULT 'primary'::"public"."audit_surface" NOT NULL,
    "action" "text" NOT NULL,
    "target" "text",
    "result" "public"."audit_result" DEFAULT 'ok'::"public"."audit_result" NOT NULL,
    "trace_id" "text",
    "payload" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL
);


ALTER TABLE "public"."audit_events" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."command_events" (
    "id" bigint NOT NULL,
    "command_id" "text" NOT NULL,
    "ts" timestamp with time zone DEFAULT "now"() NOT NULL,
    "stage" "text" NOT NULL,
    "payload" "jsonb"
);


ALTER TABLE "public"."command_events" OWNER TO "postgres";


CREATE SEQUENCE IF NOT EXISTS "public"."command_events_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE "public"."command_events_id_seq" OWNER TO "postgres";


ALTER SEQUENCE "public"."command_events_id_seq" OWNED BY "public"."command_events"."id";



CREATE TABLE IF NOT EXISTS "public"."deal_objections" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "org_id" "uuid" NOT NULL,
    "deal_id" "uuid" NOT NULL,
    "objection_code" "text" NOT NULL,
    "objection_text" "text",
    "routed_path" "text",
    "resolved" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."deal_objections" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."deals" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "org_id" "uuid" NOT NULL,
    "offer_id" "uuid",
    "lead_label" "text",
    "stage" "public"."deal_stage" DEFAULT 'new'::"public"."deal_stage" NOT NULL,
    "value_cents" integer,
    "last_action_at" timestamp with time zone,
    "notes" "text",
    CONSTRAINT "deals_value_cents_check" CHECK ((("value_cents" IS NULL) OR ("value_cents" >= 0)))
);


ALTER TABLE "public"."deals" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."decision_memos" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "org_id" "uuid",
    "sensitivity" "public"."sensitivity_level" DEFAULT 'internal'::"public"."sensitivity_level" NOT NULL,
    "title" "text" NOT NULL,
    "context_summary" "text" NOT NULL,
    "decision_question" "text" NOT NULL,
    "pros" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "cons" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "risks" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "mitigations" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "constraints" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "verdict" "public"."verdict_type" DEFAULT 'defer'::"public"."verdict_type" NOT NULL,
    "confidence" numeric,
    "economic_model" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "kpis" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "next_actions" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "tags" "text"[] DEFAULT '{}'::"text"[] NOT NULL,
    "canonical" boolean DEFAULT false NOT NULL,
    "source_ref" "text",
    "model_version" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "decision_memos_confidence_check" CHECK ((("confidence" IS NULL) OR (("confidence" >= (0)::numeric) AND ("confidence" <= (1)::numeric)))),
    CONSTRAINT "decision_memos_no_do_not_store" CHECK (("sensitivity" <> 'do_not_store'::"public"."sensitivity_level"))
);

ALTER TABLE ONLY "public"."decision_memos" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."decision_memos" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."decision_provenance" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "run_id" "uuid" NOT NULL,
    "decision_type" "text" NOT NULL,
    "source_inputs" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "expected_vs_actual" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "revenue_signal" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "evidence_count" integer DEFAULT 0 NOT NULL,
    "historical_accuracy" numeric,
    "conviction_score" numeric
);

ALTER TABLE ONLY "public"."decision_provenance" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."decision_provenance" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."economic_outcomes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "proposal_id" "uuid",
    "revenue_delta" numeric DEFAULT 0,
    "profit_delta" numeric DEFAULT 0,
    "cost_delta" numeric DEFAULT 0,
    "repeat_count" integer DEFAULT 0,
    "currency" "text" DEFAULT 'USD'::"text",
    "source" "text" DEFAULT 'manual'::"text",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."economic_outcomes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."embeddings_index" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "org_id" "uuid",
    "sensitivity" "public"."sensitivity_level" DEFAULT 'internal'::"public"."sensitivity_level" NOT NULL,
    "source" "public"."source_type" NOT NULL,
    "source_id" "uuid" NOT NULL,
    "content" "text" NOT NULL,
    "embedding" "public"."vector"(1536) NOT NULL,
    "tags" "text"[] DEFAULT '{}'::"text"[] NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_by" "uuid" NOT NULL,
    CONSTRAINT "embeddings_no_do_not_store" CHECK (("sensitivity" <> 'do_not_store'::"public"."sensitivity_level"))
);

ALTER TABLE ONLY "public"."embeddings_index" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."embeddings_index" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."engine_one_memory" (
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "prompt" "text",
    "response" "text",
    "ai_used" "text",
    "answer" "text",
    "id" bigint NOT NULL,
    "tenant_id" "uuid",
    "user_id" "uuid",
    "run_id" "uuid",
    "created_by" "uuid"
);

ALTER TABLE ONLY "public"."engine_one_memory" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."engine_one_memory" OWNER TO "postgres";


ALTER TABLE "public"."engine_one_memory" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."engine_one_memory_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."event_log" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "event_type" "text" NOT NULL,
    "message" "text" NOT NULL,
    "related_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."event_log" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."executions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "proposal_id" "uuid" NOT NULL,
    "status" "public"."execution_status" DEFAULT 'queued'::"public"."execution_status" NOT NULL,
    "executor_name" "text" DEFAULT 'ControlledExecutor'::"text" NOT NULL,
    "before_row" "jsonb" NOT NULL,
    "after_row" "jsonb",
    "applied_patch" "jsonb" NOT NULL,
    "started_at" timestamp with time zone,
    "finished_at" timestamp with time zone,
    "error" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."executions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."feature_flags" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "flag_key" "text" NOT NULL,
    "environment" "text" NOT NULL,
    "value" boolean NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."feature_flags" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."flag_proposals" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "flag_id" "uuid",
    "proposed_value" boolean NOT NULL,
    "reason" "text" NOT NULL,
    "risk_note" "text",
    "proposed_by" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "status" "text" DEFAULT 'pending'::"text" NOT NULL
);


ALTER TABLE "public"."flag_proposals" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."founder.founder_profile" (
    "founder_id" "uuid" NOT NULL,
    "role" "text" DEFAULT 'founder'::"text" NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "state" "jsonb",
    CONSTRAINT "founder_profile_role_check" CHECK (("role" = 'founder'::"text"))
);


ALTER TABLE "public"."founder.founder_profile" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."founder_state" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "operational_mode" "text" DEFAULT 'SOVEREIGN'::"text" NOT NULL,
    "last_updated" timestamp with time zone DEFAULT "now"() NOT NULL,
    "mode" "text" DEFAULT 'SOVEREIGN'::"text" NOT NULL,
    "phase" "text" DEFAULT 'ENGINE_ONE'::"text" NOT NULL,
    "next_action" "text" DEFAULT 'DEPLOY_GOVERNED_STATE_CHANGE_DEMO'::"text" NOT NULL,
    "state" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "last_change_execution_id" "uuid",
    "last_change_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."founder_state" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."health_checks" (
    "id" boolean DEFAULT true NOT NULL,
    "ok" boolean DEFAULT true NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."health_checks" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."ingestion_events" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "org_id" "uuid",
    "event_type" "text" NOT NULL,
    "payload" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."ingestion_events" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."intents" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text" NOT NULL,
    "description" "text" NOT NULL,
    "status" "public"."intent_status" DEFAULT 'draft'::"public"."intent_status" NOT NULL,
    "actor" "public"."actor_kind" NOT NULL,
    "actor_user_id" "uuid",
    "actor_agent_name" "text",
    "risk_level" integer DEFAULT 1 NOT NULL,
    "requires_human_approval" boolean DEFAULT true NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "intents_risk_level_check" CHECK ((("risk_level" >= 1) AND ("risk_level" <= 5)))
);


ALTER TABLE "public"."intents" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."kdh_rate_limits" (
    "user_id" "uuid" NOT NULL,
    "window_start" timestamp with time zone NOT NULL,
    "count" integer DEFAULT 0 NOT NULL
);


ALTER TABLE "public"."kdh_rate_limits" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."kill_switch" AS
 SELECT "id",
    "is_enabled",
    "reason",
    "updated_at",
    "enabled"
   FROM "founder"."kill_switch";


ALTER VIEW "public"."kill_switch" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."messages" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "thread_id" "uuid" NOT NULL,
    "sender_id" "uuid" NOT NULL,
    "body" "text" NOT NULL,
    "metadata" "jsonb" DEFAULT '{}'::"jsonb",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);

ALTER TABLE ONLY "public"."messages" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."messages" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."mvp_messages" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "thread_id" "uuid" NOT NULL,
    "role" "text" NOT NULL,
    "content" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "mvp_messages_role_check" CHECK (("role" = ANY (ARRAY['user'::"text", 'assistant'::"text", 'system'::"text"])))
);


ALTER TABLE "public"."mvp_messages" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."mvp_thread_summaries" (
    "thread_id" "uuid" NOT NULL,
    "summary" "text" DEFAULT ''::"text" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."mvp_thread_summaries" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."mvp_threads" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."mvp_threads" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."offers" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "org_id" "uuid" NOT NULL,
    "owner_user_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "target_buyer" "text",
    "promise" "text",
    "price_cents" integer,
    "positioning" "text",
    "status" "public"."asset_status" DEFAULT 'draft'::"public"."asset_status" NOT NULL,
    "founder_locked" boolean DEFAULT false NOT NULL,
    CONSTRAINT "offers_price_cents_check" CHECK ((("price_cents" IS NULL) OR ("price_cents" >= 0)))
);


ALTER TABLE "public"."offers" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."operating_doctrine" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "doctrine_key" "text" NOT NULL,
    "title" "text" NOT NULL,
    "version" "text" DEFAULT '1.0.0'::"text" NOT NULL,
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "body" "text" NOT NULL,
    "source" "text" DEFAULT 'founder_chat'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "operating_doctrine_status_check" CHECK (("status" = ANY (ARRAY['active'::"text", 'archived'::"text"])))
);


ALTER TABLE "public"."operating_doctrine" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."operator_tasks" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "org_id" "uuid" NOT NULL,
    "issuer_user_id" "uuid" NOT NULL,
    "task_type" "public"."task_type" NOT NULL,
    "title" "text" NOT NULL,
    "directive" "text" NOT NULL,
    "status" "public"."task_status" DEFAULT 'open'::"public"."task_status" NOT NULL,
    "due_at" timestamp with time zone,
    "completed_at" timestamp with time zone,
    "result_note" "text",
    "founder_locked" boolean DEFAULT true NOT NULL
);


ALTER TABLE "public"."operator_tasks" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."orgs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "status" "public"."org_status" DEFAULT 'active'::"public"."org_status" NOT NULL,
    "vertical" "text"
);


ALTER TABLE "public"."orgs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."os_principles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "scope" "text" NOT NULL,
    "key" "text" NOT NULL,
    "title" "text" NOT NULL,
    "statement" "text" NOT NULL,
    "rationale" "text",
    "priority" integer DEFAULT 100 NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "tags" "text"[] DEFAULT '{}'::"text"[] NOT NULL,
    "source" "text" DEFAULT 'founder_chat'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "os_principles_scope_check" CHECK (("scope" = ANY (ARRAY['founder'::"text", 'system'::"text", 'product'::"text"])))
);


ALTER TABLE "public"."os_principles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."outbound_scripts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "org_id" "uuid" NOT NULL,
    "sequence_id" "uuid",
    "offer_id" "uuid",
    "name" "text" NOT NULL,
    "script_type" "public"."script_type" NOT NULL,
    "content" "text" NOT NULL,
    "status" "public"."script_status" DEFAULT 'active'::"public"."script_status" NOT NULL,
    "founder_locked" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."outbound_scripts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."outbound_sequences" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "org_id" "uuid" NOT NULL,
    "offer_id" "uuid",
    "name" "text" NOT NULL,
    "channel" "public"."sequence_channel" DEFAULT 'multi'::"public"."sequence_channel" NOT NULL,
    "status" "public"."sequence_status" DEFAULT 'draft'::"public"."sequence_status" NOT NULL,
    "founder_locked" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."outbound_sequences" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."patterns_library" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "org_id" "uuid",
    "sensitivity" "public"."sensitivity_level" DEFAULT 'internal'::"public"."sensitivity_level" NOT NULL,
    "pattern_name" "text" NOT NULL,
    "when_to_use" "text" NOT NULL,
    "how_to_apply" "text" NOT NULL,
    "anti_patterns" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "examples" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    "tags" "text"[] DEFAULT '{}'::"text"[] NOT NULL,
    "canonical" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "patterns_no_do_not_store" CHECK (("sensitivity" <> 'do_not_store'::"public"."sensitivity_level"))
);

ALTER TABLE ONLY "public"."patterns_library" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."patterns_library" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."performance_snapshots" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "org_id" "uuid" NOT NULL,
    "period_start" "date" NOT NULL,
    "period_end" "date" NOT NULL,
    "outreaches" integer DEFAULT 0 NOT NULL,
    "replies" integer DEFAULT 0 NOT NULL,
    "booked" integer DEFAULT 0 NOT NULL,
    "closes" integer DEFAULT 0 NOT NULL,
    "revenue_cents" integer DEFAULT 0 NOT NULL,
    "failure_flags" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    CONSTRAINT "perf_period_valid" CHECK (("period_end" >= "period_start")),
    CONSTRAINT "performance_snapshots_booked_check" CHECK (("booked" >= 0)),
    CONSTRAINT "performance_snapshots_closes_check" CHECK (("closes" >= 0)),
    CONSTRAINT "performance_snapshots_outreaches_check" CHECK (("outreaches" >= 0)),
    CONSTRAINT "performance_snapshots_replies_check" CHECK (("replies" >= 0)),
    CONSTRAINT "performance_snapshots_revenue_cents_check" CHECK (("revenue_cents" >= 0))
);


ALTER TABLE "public"."performance_snapshots" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."policy_audit_snapshots" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "note" "text" NOT NULL,
    "snapshot" "jsonb" NOT NULL
);


ALTER TABLE "public"."policy_audit_snapshots" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."profiles" (
    "id" "uuid" NOT NULL,
    "email" "text",
    "role" "public"."profile_role" DEFAULT 'subscriber'::"public"."profile_role" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."proof_artifacts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "run_id" "uuid" NOT NULL,
    "artifact_type" "public"."artifact_type" NOT NULL,
    "uri" "text" NOT NULL,
    "summary" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "is_executive_brief" boolean DEFAULT false NOT NULL,
    "brief_markdown" "text",
    "visibility" "text" DEFAULT 'subscriber_default'::"text" NOT NULL,
    CONSTRAINT "proof_artifacts_visibility_check" CHECK (("visibility" = ANY (ARRAY['subscriber_default'::"text", 'subscriber_opt_in'::"text", 'founder_only'::"text"])))
);

ALTER TABLE ONLY "public"."proof_artifacts" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."proof_artifacts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."proposals" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "run_id" "uuid",
    "proposal_type" "text" NOT NULL,
    "status" "public"."proposal_status" DEFAULT 'PENDING_APPROVAL'::"public"."proposal_status" NOT NULL,
    "risk" "public"."risk_level" DEFAULT 'MEDIUM'::"public"."risk_level",
    "rationale" "text",
    "expected_outcome" "text",
    "rollback_plan" "text",
    "payload" "jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "created_by" "uuid"
);


ALTER TABLE "public"."proposals" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."reversals" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "execution_id" "uuid" NOT NULL,
    "reversed_by_user_id" "uuid" NOT NULL,
    "reversed_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "reason" "text",
    "reverted_to_row" "jsonb" NOT NULL
);


ALTER TABLE "public"."reversals" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."run_actions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "run_id" "uuid" NOT NULL,
    "action_type" "public"."action_type" NOT NULL,
    "payload" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "risk_envelope" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "status" "public"."action_status" DEFAULT 'proposed'::"public"."action_status" NOT NULL,
    "approved_by" "uuid",
    "approved_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."run_actions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."runs" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "created_by" "uuid" NOT NULL,
    "title" "text" NOT NULL,
    "status" "public"."run_status" DEFAULT 'draft'::"public"."run_status" NOT NULL,
    "confidence_level" "public"."confidence_level" DEFAULT 'medium'::"public"."confidence_level" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "archetype" "text",
    "completed_outcome" "text",
    "no_action_rationale" "text",
    "proposal_quality_score" integer,
    "outcome_quality_score" integer,
    "surface" "text",
    "intent" "text",
    "confidence" numeric DEFAULT 0.5,
    "risk_level" "text" DEFAULT 'low'::"text",
    "no_action_taken" boolean DEFAULT false,
    "summary" "text",
    "response" "text",
    "ai_used" boolean DEFAULT false,
    "escalated" boolean DEFAULT false,
    CONSTRAINT "runs_archetype_check" CHECK ((("archetype" IS NULL) OR ("archetype" = ANY (ARRAY['strategy'::"text", 'revenue'::"text", 'build'::"text", 'outreach'::"text", 'optimization'::"text", 'risk_review'::"text"])))),
    CONSTRAINT "runs_completed_outcome_check" CHECK ((("completed_outcome" IS NULL) OR ("completed_outcome" = ANY (ARRAY['executed'::"text", 'no_action_taken'::"text", 'rejected'::"text"])))),
    CONSTRAINT "runs_quality_scores_check" CHECK (((("proposal_quality_score" IS NULL) OR (("proposal_quality_score" >= 1) AND ("proposal_quality_score" <= 5))) AND (("outcome_quality_score" IS NULL) OR (("outcome_quality_score" >= 1) AND ("outcome_quality_score" <= 5)))))
);


ALTER TABLE "public"."runs" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."stripe_events" (
    "id" "text" NOT NULL,
    "tenant_id" "uuid",
    "event_type" "text" NOT NULL,
    "stripe_customer_id" "text",
    "stripe_subscription_id" "text",
    "stripe_price_id" "text",
    "amount" bigint DEFAULT 0,
    "currency" "text" DEFAULT 'usd'::"text",
    "payload" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."stripe_events" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."task_templates" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "org_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "payload" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "title" "text",
    "task_type" "text",
    "directive" "text"
);


ALTER TABLE "public"."task_templates" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tasks" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tenant_id" "uuid" NOT NULL,
    "title" "text" NOT NULL,
    "description" "text",
    "status" "text" DEFAULT 'open'::"text",
    "approval_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."tasks" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tenant_members" (
    "tenant_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "member_role" "public"."member_role" DEFAULT 'member'::"public"."member_role" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."tenant_members" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."thread_summaries" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "thread_id" "uuid" NOT NULL,
    "summary" "text",
    "model" "text",
    "tokens_used" integer,
    "created_by" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);

ALTER TABLE ONLY "public"."thread_summaries" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."thread_summaries" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."threads" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text",
    "created_by" "uuid" DEFAULT "auth"."uid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);

ALTER TABLE ONLY "public"."threads" FORCE ROW LEVEL SECURITY;


ALTER TABLE "public"."threads" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."user_org_roles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "org_id" "uuid" NOT NULL,
    "role" "public"."org_role" NOT NULL
);


ALTER TABLE "public"."user_org_roles" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_ready_to_execute" AS
 SELECT "p"."id" AS "proposal_id",
    "p"."tenant_id",
    "p"."proposal_type",
    "p"."status",
    "p"."risk",
    "p"."created_at",
    "a"."id" AS "approval_id",
    "a"."decision" AS "approval_decision",
    "a"."expires_at",
    "a"."consumed_at",
    COALESCE(("p"."payload" #>> '{target,schema}'::"text"[]), 'public'::"text") AS "target_schema",
    COALESCE(("p"."payload" #>> '{target,table}'::"text"[]), ("p"."payload" ->> 'target'::"text"), ("p"."payload" ->> 'target_table'::"text"), 'unknown'::"text") AS "target_table",
    COALESCE(("p"."payload" #>> '{target,id}'::"text"[]), ("p"."payload" ->> 'founder_state_id'::"text"), ("p"."payload" ->> 'target_id'::"text")) AS "target_id",
        CASE
            WHEN (("jsonb_typeof"(("p"."payload" #> '{patch}'::"text"[])) = 'object'::"text") AND (("p"."payload" #> '{patch}'::"text"[]) ? 'set'::"text")) THEN ("p"."payload" #> '{patch}'::"text"[])
            WHEN ("jsonb_typeof"(("p"."payload" #> '{patch}'::"text"[])) = 'object'::"text") THEN "jsonb_build_object"('set', ("p"."payload" #> '{patch}'::"text"[]))
            ELSE NULL::"jsonb"
        END AS "patch_for_rpc"
   FROM ("public"."proposals" "p"
     JOIN "public"."approvals" "a" ON ((("a"."proposal_id" = "p"."id") AND ("a"."tenant_id" = "p"."tenant_id"))))
  WHERE (("a"."decision" = 'APPROVE'::"text") AND (("a"."expires_at" IS NULL) OR ("a"."expires_at" > "now"())) AND ("a"."consumed_at" IS NULL));


ALTER VIEW "public"."v_ready_to_execute" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_receipts_index" AS
 SELECT "p"."id" AS "proposal_id",
    "p"."tenant_id",
    "p"."created_at" AS "proposal_created_at",
    "p"."updated_at" AS "proposal_updated_at",
    "p"."proposal_type",
    "p"."status" AS "proposal_status",
    "p"."risk",
    "p"."rationale",
    "p"."expected_outcome",
    "p"."rollback_plan",
    "p"."payload" AS "proposal_payload",
    "a"."id" AS "latest_approval_id",
    "a"."decision" AS "latest_approval_decision",
    "a"."expires_at" AS "latest_approval_expires_at",
    "a"."consumed_at" AS "latest_approval_consumed_at",
    "e"."id" AS "latest_execution_id",
    "e"."status" AS "latest_execution_status",
    "e"."executor_name",
    "e"."started_at" AS "execution_started_at",
    "e"."finished_at" AS "execution_finished_at",
    "count"("tal"."id") AS "tool_event_count",
    "max"("tal"."created_at") AS "last_tool_at",
    ("array_agg"("tal"."status" ORDER BY "tal"."created_at" DESC NULLS LAST))[1] AS "latest_tool_status",
    ("array_agg"("tal"."tool_name" ORDER BY "tal"."created_at" DESC NULLS LAST))[1] AS "latest_tool_name"
   FROM ((("public"."proposals" "p"
     LEFT JOIN LATERAL ( SELECT "a_1"."id",
            "a_1"."tenant_id",
            "a_1"."proposal_id",
            "a_1"."approved_by",
            "a_1"."decision",
            "a_1"."notes",
            "a_1"."approval_token_hash",
            "a_1"."expires_at",
            "a_1"."consumed_at",
            "a_1"."created_at"
           FROM "public"."approvals" "a_1"
          WHERE ("a_1"."proposal_id" = "p"."id")
          ORDER BY "a_1"."created_at" DESC NULLS LAST
         LIMIT 1) "a" ON (true))
     LEFT JOIN LATERAL ( SELECT "e_1"."id",
            "e_1"."proposal_id",
            "e_1"."status",
            "e_1"."executor_name",
            "e_1"."before_row",
            "e_1"."after_row",
            "e_1"."applied_patch",
            "e_1"."started_at",
            "e_1"."finished_at",
            "e_1"."error",
            "e_1"."created_at"
           FROM "public"."executions" "e_1"
          WHERE ("e_1"."proposal_id" = "p"."id")
          ORDER BY "e_1"."created_at" DESC NULLS LAST
         LIMIT 1) "e" ON (true))
     LEFT JOIN "public"."tool_audit_log" "tal" ON (("tal"."proposal_id" = "p"."id")))
  GROUP BY "p"."id", "p"."tenant_id", "p"."created_at", "p"."updated_at", "p"."proposal_type", "p"."status", "p"."risk", "p"."rationale", "p"."expected_outcome", "p"."rollback_plan", "p"."payload", "a"."id", "a"."decision", "a"."expires_at", "a"."consumed_at", "e"."id", "e"."status", "e"."executor_name", "e"."started_at", "e"."finished_at";


ALTER VIEW "public"."v_receipts_index" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_receipts_ledger" AS
 SELECT "p"."id" AS "proposal_id",
    "p"."tenant_id",
    "p"."proposal_type",
    "p"."status" AS "proposal_status",
    "p"."risk",
    "p"."rationale",
    "p"."created_at" AS "proposal_created_at",
    COALESCE(("p"."payload" #>> '{target,schema}'::"text"[]), 'public'::"text") AS "target_schema",
    COALESCE(("p"."payload" #>> '{target,table}'::"text"[]), ("p"."payload" ->> 'target'::"text"), ("p"."payload" ->> 'target_table'::"text"), 'unknown'::"text") AS "target_table",
    COALESCE(("p"."payload" #>> '{target,id}'::"text"[]), ("p"."payload" ->> 'founder_state_id'::"text"), ("p"."payload" ->> 'target_id'::"text")) AS "target_id",
    "a"."id" AS "approval_id",
    "a"."decision" AS "approval_decision",
    "a"."expires_at",
    "a"."consumed_at",
    "e"."id" AS "execution_id",
    "e"."status" AS "execution_status",
    "e"."executor_name",
    "e"."started_at",
    "e"."finished_at",
    "e"."applied_patch",
    "e"."before_row",
    "e"."after_row",
    "al"."created_at" AS "ledger_created_at",
    "al"."event_type" AS "ledger_event_type",
    "al"."details" AS "ledger_details"
   FROM ((("public"."proposals" "p"
     LEFT JOIN LATERAL ( SELECT "a_1"."id",
            "a_1"."tenant_id",
            "a_1"."proposal_id",
            "a_1"."approved_by",
            "a_1"."decision",
            "a_1"."notes",
            "a_1"."approval_token_hash",
            "a_1"."expires_at",
            "a_1"."consumed_at",
            "a_1"."created_at"
           FROM "public"."approvals" "a_1"
          WHERE (("a_1"."proposal_id" = "p"."id") AND ("a_1"."tenant_id" = "p"."tenant_id"))
          ORDER BY "a_1"."created_at" DESC NULLS LAST
         LIMIT 1) "a" ON (true))
     LEFT JOIN LATERAL ( SELECT "e_1"."id",
            "e_1"."proposal_id",
            "e_1"."status",
            "e_1"."executor_name",
            "e_1"."before_row",
            "e_1"."after_row",
            "e_1"."applied_patch",
            "e_1"."started_at",
            "e_1"."finished_at",
            "e_1"."error",
            "e_1"."created_at"
           FROM "public"."executions" "e_1"
          WHERE ("e_1"."proposal_id" = "p"."id")
          ORDER BY "e_1"."created_at" DESC NULLS LAST
         LIMIT 1) "e" ON (true))
     LEFT JOIN LATERAL ( SELECT "al_1"."id",
            "al_1"."event_type",
            "al_1"."actor",
            "al_1"."actor_user_id",
            "al_1"."actor_agent_name",
            "al_1"."intent_id",
            "al_1"."proposal_id",
            "al_1"."execution_id",
            "al_1"."details",
            "al_1"."created_at"
           FROM "public"."audit_ledger" "al_1"
          WHERE ("al_1"."execution_id" = "e"."id")
          ORDER BY "al_1"."created_at" DESC NULLS LAST
         LIMIT 1) "al" ON (true));


ALTER VIEW "public"."v_receipts_ledger" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_run_trace" AS
 SELECT "ra"."run_id",
    "ra"."id" AS "run_action_id",
    "ra"."action_type" AS "run_action_type",
    "ra"."status" AS "run_action_status",
    "ra"."payload" AS "run_action_payload",
    "ra"."risk_envelope" AS "run_action_risk_envelope",
    "ra"."approved_by",
    "ra"."approved_at",
    "ra"."created_at" AS "run_action_created_at",
    "tal"."id" AS "tool_log_id",
    "tal"."created_at" AS "tool_log_created_at",
    "tal"."tenant_id" AS "tool_tenant_id",
    "tal"."tool_name",
    "tal"."status" AS "tool_status",
    "tal"."input" AS "tool_input",
    "tal"."output" AS "tool_output",
    "tal"."error" AS "tool_error",
    "tal"."proposal_id",
    "tal"."approval_id"
   FROM ("public"."run_actions" "ra"
     LEFT JOIN "public"."tool_audit_log" "tal" ON (("tal"."run_id" = "ra"."run_id")));


ALTER VIEW "public"."v_run_trace" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_run_trace_enriched" AS
 SELECT "vrt"."run_id",
    "vrt"."run_action_id",
    "vrt"."run_action_type",
    "vrt"."run_action_status",
    "vrt"."run_action_payload",
    "vrt"."run_action_risk_envelope",
    "vrt"."approved_by",
    "vrt"."approved_at",
    "vrt"."run_action_created_at",
    "vrt"."tool_log_id",
    "vrt"."tool_log_created_at",
    "vrt"."tool_tenant_id",
    "vrt"."tool_name",
    "vrt"."tool_status",
    "vrt"."tool_input",
    "vrt"."tool_output",
    "vrt"."tool_error",
    "vrt"."proposal_id",
    "vrt"."approval_id",
    "p"."proposal_type",
    "p"."risk" AS "proposal_risk",
    "p"."status" AS "proposal_status",
    "p"."rationale",
    "p"."expected_outcome",
    "p"."rollback_plan",
    "p"."payload" AS "proposal_payload",
    "p"."created_at" AS "proposal_created_at",
    "a"."decision" AS "approval_decision",
    "a"."expires_at",
    "a"."consumed_at",
    "e"."id" AS "execution_id",
    "e"."status" AS "execution_status",
    "e"."executor_name",
    "e"."started_at",
    "e"."finished_at",
    "e"."applied_patch",
    "e"."before_row",
    "e"."after_row",
    "al"."created_at" AS "ledger_created_at",
    "al"."event_type" AS "ledger_event_type",
    "al"."details" AS "ledger_details"
   FROM (((("public"."v_run_trace" "vrt"
     LEFT JOIN "public"."proposals" "p" ON (("p"."id" = "vrt"."proposal_id")))
     LEFT JOIN "public"."approvals" "a" ON (("a"."id" = "vrt"."approval_id")))
     LEFT JOIN LATERAL ( SELECT "e_1"."id",
            "e_1"."proposal_id",
            "e_1"."status",
            "e_1"."executor_name",
            "e_1"."before_row",
            "e_1"."after_row",
            "e_1"."applied_patch",
            "e_1"."started_at",
            "e_1"."finished_at",
            "e_1"."error",
            "e_1"."created_at"
           FROM "public"."executions" "e_1"
          WHERE ("e_1"."proposal_id" = "vrt"."proposal_id")
          ORDER BY "e_1"."created_at" DESC NULLS LAST
         LIMIT 1) "e" ON (true))
     LEFT JOIN LATERAL ( SELECT "al_1"."id",
            "al_1"."event_type",
            "al_1"."actor",
            "al_1"."actor_user_id",
            "al_1"."actor_agent_name",
            "al_1"."intent_id",
            "al_1"."proposal_id",
            "al_1"."execution_id",
            "al_1"."details",
            "al_1"."created_at"
           FROM "public"."audit_ledger" "al_1"
          WHERE ("al_1"."execution_id" = "e"."id")
          ORDER BY "al_1"."created_at" DESC NULLS LAST
         LIMIT 1) "al" ON (true));


ALTER VIEW "public"."v_run_trace_enriched" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_runs_index" AS
 SELECT "ra"."run_id",
    "min"("ra"."created_at") AS "run_started_at",
    "max"("ra"."created_at") AS "last_action_at",
    "count"(*) AS "action_count",
    "count"(*) FILTER (WHERE ("ra"."approved_at" IS NOT NULL)) AS "approved_action_count",
    ("array_agg"("ra"."status" ORDER BY "ra"."created_at" DESC))[1] AS "latest_action_status",
    ("array_agg"("ra"."action_type" ORDER BY "ra"."created_at" DESC))[1] AS "latest_action_type",
    "count"("tal"."id") AS "tool_event_count",
    ("array_agg"("tal"."status" ORDER BY "tal"."created_at" DESC NULLS LAST))[1] AS "latest_tool_status",
    ("array_agg"("tal"."tool_name" ORDER BY "tal"."created_at" DESC NULLS LAST))[1] AS "latest_tool_name",
    "max"("tal"."created_at") AS "last_tool_at",
    ("array_agg"("tal"."proposal_id" ORDER BY "tal"."created_at" DESC NULLS LAST))[1] AS "latest_proposal_id",
    ("array_agg"("tal"."approval_id" ORDER BY "tal"."created_at" DESC NULLS LAST))[1] AS "latest_approval_id",
    ("array_agg"("tal"."tenant_id" ORDER BY "tal"."created_at" DESC NULLS LAST))[1] AS "tenant_id"
   FROM ("public"."run_actions" "ra"
     LEFT JOIN "public"."tool_audit_log" "tal" ON (("tal"."run_id" = "ra"."run_id")))
  GROUP BY "ra"."run_id";


ALTER VIEW "public"."v_runs_index" OWNER TO "postgres";


CREATE OR REPLACE VIEW "public"."v_user_tenants" AS
 SELECT "tenant_id"
   FROM "public"."tenant_members"
  WHERE ("user_id" = "auth"."uid"());


ALTER VIEW "public"."v_user_tenants" OWNER TO "postgres";


ALTER TABLE ONLY "public"."command_events" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."command_events_id_seq"'::"regclass");



ALTER TABLE ONLY "public"."ak_cockpit_override_state"
    ADD CONSTRAINT "ak_cockpit_override_state_pkey" PRIMARY KEY ("session_id");



ALTER TABLE ONLY "public"."approvals"
    ADD CONSTRAINT "approvals_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."are1_compliance_scores"
    ADD CONSTRAINT "are1_compliance_scores_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."are1_directives"
    ADD CONSTRAINT "are1_directives_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."are1_kill_switch"
    ADD CONSTRAINT "are1_kill_switch_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."are1_operator_intake"
    ADD CONSTRAINT "are1_operator_intake_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."audit_events"
    ADD CONSTRAINT "audit_events_pkey" PRIMARY KEY ("event_id");



ALTER TABLE ONLY "public"."audit_ledger"
    ADD CONSTRAINT "audit_ledger_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."command_events"
    ADD CONSTRAINT "command_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."deal_objections"
    ADD CONSTRAINT "deal_objections_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."deals"
    ADD CONSTRAINT "deals_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."decision_memos"
    ADD CONSTRAINT "decision_memos_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."decision_provenance"
    ADD CONSTRAINT "decision_provenance_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."economic_outcomes"
    ADD CONSTRAINT "economic_outcomes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."embeddings_index"
    ADD CONSTRAINT "embeddings_index_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."engine_one_memory"
    ADD CONSTRAINT "engine_one_memory_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."event_log"
    ADD CONSTRAINT "event_log_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."executions"
    ADD CONSTRAINT "executions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."feature_flags"
    ADD CONSTRAINT "feature_flags_flag_key_key" UNIQUE ("flag_key");



ALTER TABLE ONLY "public"."feature_flags"
    ADD CONSTRAINT "feature_flags_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."flag_proposals"
    ADD CONSTRAINT "flag_proposals_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."founder.founder_profile"
    ADD CONSTRAINT "founder_profile_pkey" PRIMARY KEY ("founder_id");



ALTER TABLE ONLY "public"."founder_state"
    ADD CONSTRAINT "founder_state_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."health_checks"
    ADD CONSTRAINT "health_checks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."ingestion_events"
    ADD CONSTRAINT "ingestion_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."intents"
    ADD CONSTRAINT "intents_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."kdh_rate_limits"
    ADD CONSTRAINT "kdh_rate_limits_pkey" PRIMARY KEY ("user_id", "window_start");



ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."mvp_messages"
    ADD CONSTRAINT "mvp_messages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."mvp_thread_summaries"
    ADD CONSTRAINT "mvp_thread_summaries_pkey" PRIMARY KEY ("thread_id");



ALTER TABLE ONLY "public"."mvp_threads"
    ADD CONSTRAINT "mvp_threads_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."offers"
    ADD CONSTRAINT "offers_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."are1_operator_intake"
    ADD CONSTRAINT "one_active_offer_per_operator" UNIQUE ("operator_id");



ALTER TABLE ONLY "public"."are1_directives"
    ADD CONSTRAINT "one_directive_per_operator_per_day" UNIQUE ("operator_id", "due_by");



ALTER TABLE ONLY "public"."are1_kill_switch"
    ADD CONSTRAINT "one_row_per_scope" UNIQUE ("scope");



ALTER TABLE ONLY "public"."are1_compliance_scores"
    ADD CONSTRAINT "one_score_per_intake_cycle" UNIQUE ("operator_id", "intake_id");



ALTER TABLE ONLY "public"."operating_doctrine"
    ADD CONSTRAINT "operating_doctrine_doctrine_key_key" UNIQUE ("doctrine_key");



ALTER TABLE ONLY "public"."operating_doctrine"
    ADD CONSTRAINT "operating_doctrine_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."operator_tasks"
    ADD CONSTRAINT "operator_tasks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."orgs"
    ADD CONSTRAINT "orgs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."os_principles"
    ADD CONSTRAINT "os_principles_key_key" UNIQUE ("key");



ALTER TABLE ONLY "public"."os_principles"
    ADD CONSTRAINT "os_principles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."outbound_scripts"
    ADD CONSTRAINT "outbound_scripts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."outbound_sequences"
    ADD CONSTRAINT "outbound_sequences_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."patterns_library"
    ADD CONSTRAINT "patterns_library_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."performance_snapshots"
    ADD CONSTRAINT "performance_snapshots_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."policy_audit_snapshots"
    ADD CONSTRAINT "policy_audit_snapshots_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."proof_artifacts"
    ADD CONSTRAINT "proof_artifacts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."proposals"
    ADD CONSTRAINT "proposals_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."reversals"
    ADD CONSTRAINT "reversals_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."run_actions"
    ADD CONSTRAINT "run_actions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."runs"
    ADD CONSTRAINT "runs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."stripe_events"
    ADD CONSTRAINT "stripe_events_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."task_templates"
    ADD CONSTRAINT "task_templates_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tasks"
    ADD CONSTRAINT "tasks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tenant_members"
    ADD CONSTRAINT "tenant_members_pkey" PRIMARY KEY ("tenant_id", "user_id");



ALTER TABLE ONLY "public"."tenants"
    ADD CONSTRAINT "tenants_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."thread_summaries"
    ADD CONSTRAINT "thread_summaries_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."thread_summaries"
    ADD CONSTRAINT "thread_summaries_thread_id_key" UNIQUE ("thread_id");



ALTER TABLE ONLY "public"."threads"
    ADD CONSTRAINT "threads_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tool_audit_log"
    ADD CONSTRAINT "tool_audit_log_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_org_roles"
    ADD CONSTRAINT "user_org_roles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."user_org_roles"
    ADD CONSTRAINT "user_org_roles_user_id_org_id_key" UNIQUE ("user_id", "org_id");



CREATE INDEX "ak_override_updated_idx" ON "public"."ak_cockpit_override_state" USING "btree" ("updated_at" DESC);



CREATE INDEX "approvals_active_lookup" ON "public"."approvals" USING "btree" ("proposal_id", "expires_at") WHERE ("consumed_at" IS NULL);



CREATE INDEX "approvals_approved_by_idx" ON "public"."approvals" USING "btree" ("approved_by");



CREATE INDEX "approvals_consumed_at_idx" ON "public"."approvals" USING "btree" ("consumed_at");



CREATE INDEX "approvals_expires_at_idx" ON "public"."approvals" USING "btree" ("expires_at");



CREATE UNIQUE INDEX "approvals_one_consumed_per_proposal" ON "public"."approvals" USING "btree" ("proposal_id") WHERE ("consumed_at" IS NOT NULL);



CREATE INDEX "approvals_proposal_id_idx" ON "public"."approvals" USING "btree" ("proposal_id");



CREATE INDEX "approvals_tenant_id_idx" ON "public"."approvals" USING "btree" ("tenant_id");



CREATE INDEX "audit_ledger_created_at_idx" ON "public"."audit_ledger" USING "btree" ("created_at");



CREATE INDEX "audit_ledger_details_gin" ON "public"."audit_ledger" USING "gin" ("details");



CREATE INDEX "audit_ledger_execution_id_idx" ON "public"."audit_ledger" USING "btree" ("execution_id");



CREATE INDEX "audit_ledger_intent_id_idx" ON "public"."audit_ledger" USING "btree" ("intent_id");



CREATE INDEX "audit_ledger_proposal_id_idx" ON "public"."audit_ledger" USING "btree" ("proposal_id");



CREATE INDEX "embeddings_index_created_by_idx" ON "public"."embeddings_index" USING "btree" ("created_by");



CREATE INDEX "embeddings_index_embedding_ivfflat" ON "public"."embeddings_index" USING "ivfflat" ("embedding" "public"."vector_cosine_ops") WITH ("lists"='100');



CREATE INDEX "engine_one_memory_created_by_idx" ON "public"."engine_one_memory" USING "btree" ("created_by");



CREATE INDEX "event_log_created_at_idx" ON "public"."event_log" USING "btree" ("created_at");



CREATE INDEX "event_log_event_type_created_at_idx" ON "public"."event_log" USING "btree" ("event_type", "created_at" DESC);



CREATE INDEX "event_log_related_id_idx" ON "public"."event_log" USING "btree" ("related_id");



CREATE INDEX "executions_created_at_idx" ON "public"."executions" USING "btree" ("created_at");



CREATE INDEX "executions_proposal_id_idx" ON "public"."executions" USING "btree" ("proposal_id");



CREATE INDEX "executions_status_idx" ON "public"."executions" USING "btree" ("status");



CREATE INDEX "founder_state_last_change_at_idx" ON "public"."founder_state" USING "btree" ("last_change_at" DESC);



CREATE INDEX "idx_approvals_approved_by" ON "public"."approvals" USING "btree" ("approved_by");



CREATE INDEX "idx_approvals_pending" ON "public"."approvals" USING "btree" ("tenant_id", "expires_at") WHERE ("consumed_at" IS NULL);



CREATE INDEX "idx_approvals_proposal_id" ON "public"."approvals" USING "btree" ("proposal_id");



CREATE INDEX "idx_approvals_tenant_created" ON "public"."approvals" USING "btree" ("tenant_id", "created_at" DESC);



CREATE INDEX "idx_approvals_tenant_id" ON "public"."approvals" USING "btree" ("tenant_id");



CREATE INDEX "idx_audit_ledger_proposal" ON "public"."audit_ledger" USING "btree" ("proposal_id", "created_at" DESC);



CREATE INDEX "idx_audit_ledger_run" ON "public"."audit_ledger" USING "btree" ("intent_id", "created_at" DESC);



CREATE INDEX "idx_audit_org" ON "public"."audit_events" USING "btree" ("org_id");



CREATE INDEX "idx_command_events_command_id" ON "public"."command_events" USING "btree" ("command_id");



CREATE INDEX "idx_deals_org" ON "public"."deals" USING "btree" ("org_id");



CREATE INDEX "idx_decision_memos_created_at" ON "public"."decision_memos" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_decision_memos_owner" ON "public"."decision_memos" USING "btree" ("owner_id");



CREATE INDEX "idx_decision_memos_tags" ON "public"."decision_memos" USING "gin" ("tags");



CREATE INDEX "idx_decision_provenance_run" ON "public"."decision_provenance" USING "btree" ("run_id");



CREATE INDEX "idx_economic_outcomes_proposal_id" ON "public"."economic_outcomes" USING "btree" ("proposal_id");



CREATE INDEX "idx_economic_outcomes_tenant_id" ON "public"."economic_outcomes" USING "btree" ("tenant_id");



CREATE INDEX "idx_embeddings_owner" ON "public"."embeddings_index" USING "btree" ("owner_id");



CREATE INDEX "idx_embeddings_source" ON "public"."embeddings_index" USING "btree" ("source", "source_id");



CREATE INDEX "idx_embeddings_tags" ON "public"."embeddings_index" USING "gin" ("tags");



CREATE INDEX "idx_embeddings_vector" ON "public"."embeddings_index" USING "ivfflat" ("embedding" "public"."vector_cosine_ops") WITH ("lists"='100');



CREATE INDEX "idx_engine_one_memory_run_id" ON "public"."engine_one_memory" USING "btree" ("run_id");



CREATE INDEX "idx_engine_one_memory_tenant_id" ON "public"."engine_one_memory" USING "btree" ("tenant_id");



CREATE INDEX "idx_engine_one_memory_user_id" ON "public"."engine_one_memory" USING "btree" ("user_id");



CREATE INDEX "idx_executions_proposal" ON "public"."executions" USING "btree" ("proposal_id");



CREATE INDEX "idx_executions_status" ON "public"."executions" USING "btree" ("status", "created_at" DESC);



CREATE INDEX "idx_ingestion_events_created" ON "public"."ingestion_events" USING "btree" ("created_at" DESC);



CREATE INDEX "idx_ingestion_events_owner" ON "public"."ingestion_events" USING "btree" ("owner_id");



CREATE INDEX "idx_messages_sender_id" ON "public"."messages" USING "btree" ("sender_id");



CREATE INDEX "idx_messages_thread_created" ON "public"."messages" USING "btree" ("thread_id", "created_at");



CREATE INDEX "idx_messages_thread_id" ON "public"."messages" USING "btree" ("thread_id");



CREATE INDEX "idx_mvp_messages_thread_created" ON "public"."mvp_messages" USING "btree" ("thread_id", "created_at");



CREATE INDEX "idx_objections_org" ON "public"."deal_objections" USING "btree" ("org_id");



CREATE INDEX "idx_offers_org" ON "public"."offers" USING "btree" ("org_id");



CREATE INDEX "idx_patterns_owner" ON "public"."patterns_library" USING "btree" ("owner_id");



CREATE INDEX "idx_patterns_tags" ON "public"."patterns_library" USING "gin" ("tags");



CREATE INDEX "idx_perf_org" ON "public"."performance_snapshots" USING "btree" ("org_id");



CREATE INDEX "idx_proof_artifacts_run" ON "public"."proof_artifacts" USING "btree" ("run_id");



CREATE INDEX "idx_proposals_run_id" ON "public"."proposals" USING "btree" ("run_id");



CREATE INDEX "idx_proposals_tenant_id" ON "public"."proposals" USING "btree" ("tenant_id");



CREATE INDEX "idx_proposals_tenant_status" ON "public"."proposals" USING "btree" ("tenant_id", "status");



CREATE INDEX "idx_reversals_execution" ON "public"."reversals" USING "btree" ("execution_id");



CREATE INDEX "idx_run_actions_approved_by" ON "public"."run_actions" USING "btree" ("approved_by");



CREATE INDEX "idx_run_actions_run" ON "public"."run_actions" USING "btree" ("run_id");



CREATE INDEX "idx_runs_created_by" ON "public"."runs" USING "btree" ("created_by");



CREATE INDEX "idx_runs_tenant" ON "public"."runs" USING "btree" ("tenant_id");



CREATE INDEX "idx_runs_tenant_created" ON "public"."runs" USING "btree" ("tenant_id", "created_at" DESC);



CREATE INDEX "idx_runs_tenant_status" ON "public"."runs" USING "btree" ("tenant_id", "status");



CREATE INDEX "idx_scripts_org" ON "public"."outbound_scripts" USING "btree" ("org_id");



CREATE INDEX "idx_sequences_org" ON "public"."outbound_sequences" USING "btree" ("org_id");



CREATE INDEX "idx_stripe_events_customer" ON "public"."stripe_events" USING "btree" ("stripe_customer_id");



CREATE INDEX "idx_stripe_events_subscription" ON "public"."stripe_events" USING "btree" ("stripe_subscription_id");



CREATE INDEX "idx_stripe_events_tenant_created" ON "public"."stripe_events" USING "btree" ("tenant_id", "created_at" DESC);



CREATE INDEX "idx_task_templates_org" ON "public"."task_templates" USING "btree" ("org_id");



CREATE INDEX "idx_task_templates_org_id" ON "public"."task_templates" USING "btree" ("org_id");



CREATE INDEX "idx_tasks_approval_id" ON "public"."tasks" USING "btree" ("approval_id");



CREATE INDEX "idx_tasks_org" ON "public"."operator_tasks" USING "btree" ("org_id");



CREATE INDEX "idx_tasks_tenant_id" ON "public"."tasks" USING "btree" ("tenant_id");



CREATE INDEX "idx_tenant_members_tenant_id" ON "public"."tenant_members" USING "btree" ("tenant_id");



CREATE INDEX "idx_tenant_members_tenant_user" ON "public"."tenant_members" USING "btree" ("tenant_id", "user_id");



CREATE INDEX "idx_tenant_members_user" ON "public"."tenant_members" USING "btree" ("user_id");



CREATE INDEX "idx_tenants_stripe_sub" ON "public"."tenants" USING "btree" ("stripe_subscription_id");



CREATE INDEX "idx_tool_audit_log_approval_id" ON "public"."tool_audit_log" USING "btree" ("approval_id");



CREATE INDEX "idx_tool_audit_log_proposal_id" ON "public"."tool_audit_log" USING "btree" ("proposal_id");



CREATE INDEX "idx_tool_audit_log_run_id" ON "public"."tool_audit_log" USING "btree" ("run_id");



CREATE INDEX "idx_tool_audit_log_tenant_id" ON "public"."tool_audit_log" USING "btree" ("tenant_id");



CREATE INDEX "idx_tool_audit_proposal" ON "public"."tool_audit_log" USING "btree" ("proposal_id", "created_at" DESC);



CREATE INDEX "idx_tool_audit_run" ON "public"."tool_audit_log" USING "btree" ("run_id", "created_at" DESC);



CREATE INDEX "idx_user_org_roles_org" ON "public"."user_org_roles" USING "btree" ("org_id");



CREATE INDEX "idx_user_org_roles_user" ON "public"."user_org_roles" USING "btree" ("user_id");



CREATE INDEX "kdh_rate_limits_window_start_idx" ON "public"."kdh_rate_limits" USING "btree" ("window_start");



CREATE INDEX "messages_created_at_idx" ON "public"."messages" USING "btree" ("created_at");



CREATE INDEX "messages_sender_id_idx" ON "public"."messages" USING "btree" ("sender_id");



CREATE INDEX "messages_thread_id_idx" ON "public"."messages" USING "btree" ("thread_id");



CREATE INDEX "mvp_messages_thread_id_idx" ON "public"."mvp_messages" USING "btree" ("thread_id", "created_at");



CREATE INDEX "os_principles_active_idx" ON "public"."os_principles" USING "btree" ("is_active");



CREATE INDEX "os_principles_key_idx" ON "public"."os_principles" USING "btree" ("key");



CREATE INDEX "os_principles_scope_priority_idx" ON "public"."os_principles" USING "btree" ("scope", "priority");



CREATE INDEX "proposals_created_at_idx" ON "public"."proposals" USING "btree" ("created_at");



CREATE INDEX "proposals_payload_gin" ON "public"."proposals" USING "gin" ("payload");



CREATE INDEX "proposals_payload_idx" ON "public"."proposals" USING "gin" ("payload");



CREATE INDEX "proposals_run_id_idx" ON "public"."proposals" USING "btree" ("run_id");



CREATE INDEX "proposals_status_idx" ON "public"."proposals" USING "btree" ("status");



CREATE INDEX "proposals_tenant_id_idx" ON "public"."proposals" USING "btree" ("tenant_id");



CREATE INDEX "reversals_execution_id_idx" ON "public"."reversals" USING "btree" ("execution_id");



CREATE INDEX "reversals_reversed_by_idx" ON "public"."reversals" USING "btree" ("reversed_by_user_id");



CREATE INDEX "run_actions_payload_gin" ON "public"."run_actions" USING "gin" ("payload");



CREATE INDEX "runs_created_at_idx" ON "public"."runs" USING "btree" ("created_at");



CREATE INDEX "runs_created_by_idx" ON "public"."runs" USING "btree" ("created_by");



CREATE INDEX "runs_status_idx" ON "public"."runs" USING "btree" ("status");



CREATE INDEX "runs_tenant_id_idx" ON "public"."runs" USING "btree" ("tenant_id");



CREATE INDEX "stripe_events_created_at_idx" ON "public"."stripe_events" USING "btree" ("created_at");



CREATE INDEX "stripe_events_customer_idx" ON "public"."stripe_events" USING "btree" ("stripe_customer_id");



CREATE INDEX "stripe_events_subscription_idx" ON "public"."stripe_events" USING "btree" ("stripe_subscription_id");



CREATE INDEX "stripe_events_tenant_id_idx" ON "public"."stripe_events" USING "btree" ("tenant_id");



CREATE INDEX "tasks_approval_id_idx" ON "public"."tasks" USING "btree" ("approval_id");



CREATE INDEX "tasks_tenant_id_idx" ON "public"."tasks" USING "btree" ("tenant_id");



CREATE OR REPLACE TRIGGER "intents_set_updated_at" BEFORE UPDATE ON "public"."intents" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "no_delete_health_checks" BEFORE DELETE ON "public"."health_checks" FOR EACH ROW EXECUTE FUNCTION "public"."prevent_health_checks_delete"();



CREATE OR REPLACE TRIGGER "os_principles_set_updated_at" BEFORE UPDATE ON "public"."os_principles" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "set_updated_at_on_decision_memos" BEFORE UPDATE ON "public"."decision_memos" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "set_updated_at_on_proposals" BEFORE UPDATE ON "public"."proposals" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "trg_audit_events_guard" BEFORE INSERT ON "public"."audit_events" FOR EACH ROW EXECUTE FUNCTION "public"."audit_events_guard"();



CREATE OR REPLACE TRIGGER "trg_audit_events_immutable" BEFORE DELETE OR UPDATE ON "public"."audit_events" FOR EACH ROW EXECUTE FUNCTION "public"."audit_events_immutable"();



CREATE OR REPLACE TRIGGER "trg_decision_memos_updated" BEFORE UPDATE ON "public"."decision_memos" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "trg_engine_one_memory_set_created_by" BEFORE INSERT ON "public"."engine_one_memory" FOR EACH ROW EXECUTE FUNCTION "public"."set_created_by"();



CREATE OR REPLACE TRIGGER "trg_normalize_approval_decision" BEFORE INSERT OR UPDATE ON "public"."approvals" FOR EACH ROW EXECUTE FUNCTION "public"."normalize_approval_decision"();



CREATE OR REPLACE TRIGGER "trg_patterns_updated" BEFORE UPDATE ON "public"."patterns_library" FOR EACH ROW EXECUTE FUNCTION "public"."set_updated_at"();



CREATE OR REPLACE TRIGGER "trg_proposals_updated" BEFORE UPDATE ON "public"."proposals" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



CREATE OR REPLACE TRIGGER "trg_runs_no_action_rationale" BEFORE INSERT OR UPDATE ON "public"."runs" FOR EACH ROW EXECUTE FUNCTION "public"."enforce_no_action_rationale"();



CREATE OR REPLACE TRIGGER "trg_runs_updated" BEFORE UPDATE ON "public"."runs" FOR EACH ROW EXECUTE FUNCTION "public"."touch_updated_at"();



ALTER TABLE ONLY "public"."approvals"
    ADD CONSTRAINT "approvals_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "auth"."users"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."approvals"
    ADD CONSTRAINT "approvals_proposal_id_fkey" FOREIGN KEY ("proposal_id") REFERENCES "public"."proposals"("id");



ALTER TABLE ONLY "public"."approvals"
    ADD CONSTRAINT "approvals_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id");



ALTER TABLE ONLY "public"."audit_events"
    ADD CONSTRAINT "audit_events_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "auth"."users"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."audit_events"
    ADD CONSTRAINT "audit_events_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."deal_objections"
    ADD CONSTRAINT "deal_objections_deal_id_fkey" FOREIGN KEY ("deal_id") REFERENCES "public"."deals"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."deal_objections"
    ADD CONSTRAINT "deal_objections_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."deals"
    ADD CONSTRAINT "deals_offer_id_fkey" FOREIGN KEY ("offer_id") REFERENCES "public"."offers"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."deals"
    ADD CONSTRAINT "deals_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."decision_provenance"
    ADD CONSTRAINT "decision_provenance_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "public"."runs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."economic_outcomes"
    ADD CONSTRAINT "economic_outcomes_proposal_id_fkey" FOREIGN KEY ("proposal_id") REFERENCES "public"."proposals"("id");



ALTER TABLE ONLY "public"."economic_outcomes"
    ADD CONSTRAINT "economic_outcomes_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id");



ALTER TABLE ONLY "public"."engine_one_memory"
    ADD CONSTRAINT "engine_one_memory_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "public"."runs"("id");



ALTER TABLE ONLY "public"."engine_one_memory"
    ADD CONSTRAINT "engine_one_memory_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id");



ALTER TABLE ONLY "public"."engine_one_memory"
    ADD CONSTRAINT "engine_one_memory_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."executions"
    ADD CONSTRAINT "executions_proposal_id_fkey" FOREIGN KEY ("proposal_id") REFERENCES "public"."proposals"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."are1_compliance_scores"
    ADD CONSTRAINT "fk_intake" FOREIGN KEY ("intake_id") REFERENCES "public"."are1_operator_intake"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."are1_directives"
    ADD CONSTRAINT "fk_intake_directive" FOREIGN KEY ("intake_id") REFERENCES "public"."are1_operator_intake"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."flag_proposals"
    ADD CONSTRAINT "flag_proposals_flag_id_fkey" FOREIGN KEY ("flag_id") REFERENCES "public"."feature_flags"("id");



ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_thread_id_fkey" FOREIGN KEY ("thread_id") REFERENCES "public"."threads"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."mvp_messages"
    ADD CONSTRAINT "mvp_messages_thread_id_fkey" FOREIGN KEY ("thread_id") REFERENCES "public"."mvp_threads"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."mvp_thread_summaries"
    ADD CONSTRAINT "mvp_thread_summaries_thread_id_fkey" FOREIGN KEY ("thread_id") REFERENCES "public"."mvp_threads"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."offers"
    ADD CONSTRAINT "offers_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."offers"
    ADD CONSTRAINT "offers_owner_user_id_fkey" FOREIGN KEY ("owner_user_id") REFERENCES "auth"."users"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."operator_tasks"
    ADD CONSTRAINT "operator_tasks_issuer_user_id_fkey" FOREIGN KEY ("issuer_user_id") REFERENCES "auth"."users"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."operator_tasks"
    ADD CONSTRAINT "operator_tasks_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."outbound_scripts"
    ADD CONSTRAINT "outbound_scripts_offer_id_fkey" FOREIGN KEY ("offer_id") REFERENCES "public"."offers"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."outbound_scripts"
    ADD CONSTRAINT "outbound_scripts_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."outbound_scripts"
    ADD CONSTRAINT "outbound_scripts_sequence_id_fkey" FOREIGN KEY ("sequence_id") REFERENCES "public"."outbound_sequences"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."outbound_sequences"
    ADD CONSTRAINT "outbound_sequences_offer_id_fkey" FOREIGN KEY ("offer_id") REFERENCES "public"."offers"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."outbound_sequences"
    ADD CONSTRAINT "outbound_sequences_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."performance_snapshots"
    ADD CONSTRAINT "performance_snapshots_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."proof_artifacts"
    ADD CONSTRAINT "proof_artifacts_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "public"."runs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."proposals"
    ADD CONSTRAINT "proposals_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "public"."runs"("id");



ALTER TABLE ONLY "public"."proposals"
    ADD CONSTRAINT "proposals_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."reversals"
    ADD CONSTRAINT "reversals_execution_id_fkey" FOREIGN KEY ("execution_id") REFERENCES "public"."executions"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."run_actions"
    ADD CONSTRAINT "run_actions_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "auth"."users"("id");



ALTER TABLE ONLY "public"."run_actions"
    ADD CONSTRAINT "run_actions_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "public"."runs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."runs"
    ADD CONSTRAINT "runs_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "auth"."users"("id") ON DELETE RESTRICT;



ALTER TABLE ONLY "public"."runs"
    ADD CONSTRAINT "runs_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stripe_events"
    ADD CONSTRAINT "stripe_events_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."tasks"
    ADD CONSTRAINT "tasks_approval_id_fkey" FOREIGN KEY ("approval_id") REFERENCES "public"."approvals"("id");



ALTER TABLE ONLY "public"."tasks"
    ADD CONSTRAINT "tasks_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id");



ALTER TABLE ONLY "public"."tenant_members"
    ADD CONSTRAINT "tenant_members_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tenant_members"
    ADD CONSTRAINT "tenant_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."thread_summaries"
    ADD CONSTRAINT "thread_summaries_thread_id_fkey" FOREIGN KEY ("thread_id") REFERENCES "public"."threads"("id");



ALTER TABLE ONLY "public"."tool_audit_log"
    ADD CONSTRAINT "tool_audit_log_approval_id_fkey" FOREIGN KEY ("approval_id") REFERENCES "public"."approvals"("id");



ALTER TABLE ONLY "public"."tool_audit_log"
    ADD CONSTRAINT "tool_audit_log_proposal_id_fkey" FOREIGN KEY ("proposal_id") REFERENCES "public"."proposals"("id");



ALTER TABLE ONLY "public"."tool_audit_log"
    ADD CONSTRAINT "tool_audit_log_run_id_fkey" FOREIGN KEY ("run_id") REFERENCES "public"."runs"("id");



ALTER TABLE ONLY "public"."tool_audit_log"
    ADD CONSTRAINT "tool_audit_log_tenant_id_fkey" FOREIGN KEY ("tenant_id") REFERENCES "public"."tenants"("id");



ALTER TABLE ONLY "public"."user_org_roles"
    ADD CONSTRAINT "user_org_roles_org_id_fkey" FOREIGN KEY ("org_id") REFERENCES "public"."orgs"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."user_org_roles"
    ADD CONSTRAINT "user_org_roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE "public"."ak_cockpit_override_state" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."approvals" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."are1_compliance_scores" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."are1_directives" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "are1_directives_select_self" ON "public"."are1_directives" FOR SELECT TO "authenticated" USING (("operator_id" = "auth"."uid"()));



CREATE POLICY "are1_intake_insert_self" ON "public"."are1_operator_intake" FOR INSERT TO "authenticated" WITH CHECK (("operator_id" = "auth"."uid"()));



CREATE POLICY "are1_intake_select_self" ON "public"."are1_operator_intake" FOR SELECT TO "authenticated" USING (("operator_id" = "auth"."uid"()));



ALTER TABLE "public"."are1_kill_switch" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "are1_kill_switch_select_readonly" ON "public"."are1_kill_switch" FOR SELECT TO "authenticated" USING (("scope" = 'ARE-1'::"text"));



ALTER TABLE "public"."are1_operator_intake" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "are1_scores_select_self" ON "public"."are1_compliance_scores" FOR SELECT TO "authenticated" USING (("operator_id" = "auth"."uid"()));



ALTER TABLE "public"."audit_events" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "audit_insert" ON "public"."audit_events" FOR INSERT WITH CHECK (true);



ALTER TABLE "public"."audit_ledger" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "audit_read_only" ON "public"."audit_ledger" FOR SELECT USING (true);



CREATE POLICY "audit_select" ON "public"."audit_events" FOR SELECT USING ((("org_id" IS NOT NULL) AND "public"."is_founder"("org_id")));



ALTER TABLE "public"."deal_objections" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."deals" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "deals_insert" ON "public"."deals" FOR INSERT WITH CHECK ("public"."is_operator"("org_id"));



CREATE POLICY "deals_select" ON "public"."deals" FOR SELECT USING (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id")));



CREATE POLICY "deals_update" ON "public"."deals" FOR UPDATE USING (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id"))) WITH CHECK (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id")));



ALTER TABLE "public"."decision_memos" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."decision_provenance" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."economic_outcomes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."embeddings_index" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."engine_one_memory" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."event_log" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "event_log_founder_only" ON "public"."event_log" TO "authenticated" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



ALTER TABLE "public"."executions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."feature_flags" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "feature_flags_founder_only" ON "public"."feature_flags" TO "authenticated" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



ALTER TABLE "public"."flag_proposals" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "flag_proposals_founder_only" ON "public"."flag_proposals" TO "authenticated" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder can read founder_profile" ON "public"."founder.founder_profile" FOR SELECT USING (("auth"."uid"() = "founder_id"));



CREATE POLICY "founder can write founder_profile" ON "public"."founder.founder_profile" USING (("auth"."uid"() = "founder_id")) WITH CHECK (("auth"."uid"() = "founder_id"));



CREATE POLICY "founder-only" ON "public"."ak_cockpit_override_state" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."approvals" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."decision_memos" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."decision_provenance" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."economic_outcomes" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."embeddings_index" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."engine_one_memory" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."ingestion_events" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."kdh_rate_limits" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."messages" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."mvp_messages" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."mvp_thread_summaries" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."mvp_threads" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."operating_doctrine" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."os_principles" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."patterns_library" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."policy_audit_snapshots" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."proof_artifacts" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."proposals" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."run_actions" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."runs" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."stripe_events" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."tasks" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."tenant_members" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."tenants" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."thread_summaries" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."threads" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



CREATE POLICY "founder-only" ON "public"."tool_audit_log" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



ALTER TABLE "public"."founder.founder_profile" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "founder_delete_threads" ON "public"."mvp_threads" FOR DELETE TO "authenticated" USING (false);



ALTER TABLE "public"."founder_state" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "founder_update_threads" ON "public"."mvp_threads" FOR UPDATE TO "authenticated" USING (false);



ALTER TABLE "public"."health_checks" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "health_checks_select_anon" ON "public"."health_checks" FOR SELECT TO "anon" USING (true);



ALTER TABLE "public"."ingestion_events" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."intents" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "intents_founder_only" ON "public"."intents" TO "authenticated" USING ("public"."is_founder"()) WITH CHECK ("public"."is_founder"());



ALTER TABLE "public"."kdh_rate_limits" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."messages" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."mvp_messages" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."mvp_thread_summaries" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."mvp_threads" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "obj_insert" ON "public"."deal_objections" FOR INSERT WITH CHECK ("public"."is_operator"("org_id"));



CREATE POLICY "obj_select" ON "public"."deal_objections" FOR SELECT USING (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id")));



CREATE POLICY "obj_update" ON "public"."deal_objections" FOR UPDATE USING (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id"))) WITH CHECK (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id")));



ALTER TABLE "public"."offers" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "offers_insert" ON "public"."offers" FOR INSERT WITH CHECK (("public"."is_operator"("org_id") AND ("owner_user_id" = "auth"."uid"()) AND ("status" = 'draft'::"public"."asset_status") AND ("founder_locked" = false)));



CREATE POLICY "offers_select" ON "public"."offers" FOR SELECT USING (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id")));



CREATE POLICY "offers_update" ON "public"."offers" FOR UPDATE USING (("public"."is_founder"("org_id") OR ("public"."is_operator"("org_id") AND ("founder_locked" = false) AND ("owner_user_id" = "auth"."uid"())))) WITH CHECK (("public"."is_founder"("org_id") OR ("public"."is_operator"("org_id") AND ("founder_locked" = false) AND ("owner_user_id" = "auth"."uid"()))));



ALTER TABLE "public"."operating_doctrine" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."operator_tasks" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."orgs" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "orgs_select" ON "public"."orgs" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."user_org_roles" "uor"
  WHERE (("uor"."user_id" = "auth"."uid"()) AND ("uor"."org_id" = "orgs"."id")))));



CREATE POLICY "orgs_write" ON "public"."orgs" USING (false) WITH CHECK (false);



ALTER TABLE "public"."os_principles" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."outbound_scripts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."outbound_sequences" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."patterns_library" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "perf_insert" ON "public"."performance_snapshots" FOR INSERT WITH CHECK ("public"."is_operator"("org_id"));



CREATE POLICY "perf_select" ON "public"."performance_snapshots" FOR SELECT USING (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id")));



CREATE POLICY "perf_update" ON "public"."performance_snapshots" FOR UPDATE USING ("public"."is_founder"("org_id")) WITH CHECK ("public"."is_founder"("org_id"));



ALTER TABLE "public"."performance_snapshots" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."policy_audit_snapshots" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "profiles_read_own" ON "public"."profiles" FOR SELECT USING (("id" = "auth"."uid"()));



CREATE POLICY "profiles_update_own" ON "public"."profiles" FOR UPDATE USING (("id" = "auth"."uid"())) WITH CHECK (("id" = "auth"."uid"()));



ALTER TABLE "public"."proof_artifacts" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."proposals" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "read task templates" ON "public"."task_templates" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "read task templates anon" ON "public"."task_templates" FOR SELECT TO "anon" USING (true);



ALTER TABLE "public"."reversals" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."run_actions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."runs" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "scripts_insert" ON "public"."outbound_scripts" FOR INSERT WITH CHECK (("public"."is_operator"("org_id") AND ("founder_locked" = false)));



CREATE POLICY "scripts_select" ON "public"."outbound_scripts" FOR SELECT USING (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id")));



CREATE POLICY "scripts_update" ON "public"."outbound_scripts" FOR UPDATE USING (("public"."is_founder"("org_id") OR ("public"."is_operator"("org_id") AND ("founder_locked" = false)))) WITH CHECK (("public"."is_founder"("org_id") OR ("public"."is_operator"("org_id") AND ("founder_locked" = false))));



CREATE POLICY "seq_insert" ON "public"."outbound_sequences" FOR INSERT WITH CHECK (("public"."is_operator"("org_id") AND ("status" = 'draft'::"public"."sequence_status") AND ("founder_locked" = false)));



CREATE POLICY "seq_select" ON "public"."outbound_sequences" FOR SELECT USING (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id")));



CREATE POLICY "seq_update" ON "public"."outbound_sequences" FOR UPDATE USING (("public"."is_founder"("org_id") OR ("public"."is_operator"("org_id") AND ("founder_locked" = false)))) WITH CHECK (("public"."is_founder"("org_id") OR ("public"."is_operator"("org_id") AND ("founder_locked" = false))));



CREATE POLICY "service_role_all" ON "public"."executions" TO "service_role" USING (true) WITH CHECK (true);



CREATE POLICY "service_role_all" ON "public"."founder_state" TO "service_role" USING (true) WITH CHECK (true);



CREATE POLICY "service_role_all" ON "public"."reversals" TO "service_role" USING (true) WITH CHECK (true);



ALTER TABLE "public"."stripe_events" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."task_templates" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "task_templates_delete" ON "public"."task_templates" FOR DELETE USING (false);



CREATE POLICY "task_templates_insert" ON "public"."task_templates" FOR INSERT WITH CHECK ("public"."is_founder"("org_id"));



CREATE POLICY "task_templates_select" ON "public"."task_templates" FOR SELECT USING ("public"."is_founder"("org_id"));



CREATE POLICY "task_templates_update" ON "public"."task_templates" FOR UPDATE USING ("public"."is_founder"("org_id")) WITH CHECK ("public"."is_founder"("org_id"));



ALTER TABLE "public"."tasks" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "tasks_select" ON "public"."operator_tasks" FOR SELECT USING (("public"."is_founder"("org_id") OR "public"."is_operator"("org_id")));



CREATE POLICY "tasks_write_closed" ON "public"."operator_tasks" USING (false) WITH CHECK (false);



ALTER TABLE "public"."tenant_members" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."tenants" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."thread_summaries" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."threads" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."tool_audit_log" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "uor_select" ON "public"."user_org_roles" FOR SELECT USING ((("user_id" = "auth"."uid"()) OR "public"."is_founder"("org_id")));



CREATE POLICY "uor_write" ON "public"."user_org_roles" USING (false) WITH CHECK (false);



ALTER TABLE "public"."user_org_roles" ENABLE ROW LEVEL SECURITY;


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



REVOKE ALL ON FUNCTION "public"."approve_run_action"("p_action_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."approve_run_action"("p_action_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."are1_issue_directive"("p_operator_id" "uuid", "p_intake_id" "uuid", "p_issued_actions" integer, "p_due_by" "date") TO "service_role";



GRANT ALL ON FUNCTION "public"."are1_upsert_compliance_score"("p_operator_id" "uuid", "p_intake_id" "uuid", "p_issued_actions" integer, "p_completed_actions" integer) TO "service_role";



GRANT ALL ON FUNCTION "public"."audit_events_guard"() TO "service_role";



GRANT ALL ON FUNCTION "public"."audit_events_immutable"() TO "service_role";



GRANT ALL ON FUNCTION "public"."current_role"("_org_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."enforce_no_action_rationale"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."enforce_no_action_rationale"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."execute_approved_founder_state_change"("p_tenant_id" "uuid", "p_proposal_id" "uuid", "p_founder_state_id" "uuid", "p_patch" "jsonb") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."execute_approved_founder_state_change"("p_tenant_id" "uuid", "p_proposal_id" "uuid", "p_founder_state_id" "uuid", "p_patch" "jsonb") TO "service_role";



REVOKE ALL ON FUNCTION "public"."handle_new_user"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."is_founder"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."is_founder"() TO "service_role";
GRANT ALL ON FUNCTION "public"."is_founder"() TO "authenticated";



GRANT ALL ON FUNCTION "public"."is_founder"("_org_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."is_founder_debug"("user_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."is_founder_debug"("user_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."is_member_of_tenant"("tid" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."is_member_of_tenant"("tid" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."is_operator"("_org_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."is_row_owner"("row_user_id" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."is_row_owner"("row_user_id" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."is_thread_owner"("thread_uuid" "uuid") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."is_thread_owner"("thread_uuid" "uuid") TO "service_role";



REVOKE ALL ON FUNCTION "public"."kdh_check_rate_limit"("max_requests" integer, "window_seconds" integer) FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."kdh_check_rate_limit"("max_requests" integer, "window_seconds" integer) TO "service_role";
GRANT ALL ON FUNCTION "public"."kdh_check_rate_limit"("max_requests" integer, "window_seconds" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."kdh_check_rate_limit"("max_requests" integer, "window_seconds" integer) TO "authenticated";



REVOKE ALL ON FUNCTION "public"."normalize_approval_decision"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."normalize_approval_decision"() TO "service_role";



GRANT ALL ON FUNCTION "public"."prevent_health_checks_delete"() TO "service_role";



GRANT ALL ON FUNCTION "public"."rpc_append_audit"("p_org_id" "uuid", "p_surface" "public"."audit_surface", "p_action" "text", "p_target" "text", "p_result" "public"."audit_result", "p_trace_id" "text", "p_payload" "jsonb") TO "service_role";
GRANT ALL ON FUNCTION "public"."rpc_append_audit"("p_org_id" "uuid", "p_surface" "public"."audit_surface", "p_action" "text", "p_target" "text", "p_result" "public"."audit_result", "p_trace_id" "text", "p_payload" "jsonb") TO "authenticated";



GRANT ALL ON FUNCTION "public"."rpc_issue_task"("p_org_id" "uuid", "p_task_type" "public"."task_type", "p_title" "text", "p_directive" "text", "p_due_at" timestamp with time zone, "p_founder_locked" boolean, "p_surface" "public"."audit_surface", "p_trace_id" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."rpc_issue_task"("p_org_id" "uuid", "p_task_type" "public"."task_type", "p_title" "text", "p_directive" "text", "p_due_at" timestamp with time zone, "p_founder_locked" boolean, "p_surface" "public"."audit_surface", "p_trace_id" "text") TO "authenticated";



GRANT ALL ON FUNCTION "public"."rpc_issue_task_from_template"("p_org_id" "uuid", "p_template_id" "uuid", "p_due_at" timestamp with time zone, "p_surface" "public"."audit_surface", "p_trace_id" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."rpc_issue_task_from_template"("p_org_id" "uuid", "p_template_id" "uuid", "p_due_at" timestamp with time zone, "p_surface" "public"."audit_surface", "p_trace_id" "text") TO "authenticated";



GRANT ALL ON FUNCTION "public"."rpc_log_performance_snapshot"("p_org_id" "uuid", "p_period_start" "date", "p_period_end" "date", "p_outreaches" integer, "p_replies" integer, "p_booked" integer, "p_closes" integer, "p_revenue_cents" integer, "p_failure_flags" "jsonb", "p_surface" "public"."audit_surface", "p_trace_id" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."rpc_log_performance_snapshot"("p_org_id" "uuid", "p_period_start" "date", "p_period_end" "date", "p_outreaches" integer, "p_replies" integer, "p_booked" integer, "p_closes" integer, "p_revenue_cents" integer, "p_failure_flags" "jsonb", "p_surface" "public"."audit_surface", "p_trace_id" "text") TO "authenticated";



GRANT ALL ON FUNCTION "public"."rpc_task_set_status"("p_task_id" "uuid", "p_status" "public"."task_status", "p_result_note" "text", "p_surface" "public"."audit_surface", "p_trace_id" "text") TO "service_role";
GRANT ALL ON FUNCTION "public"."rpc_task_set_status"("p_task_id" "uuid", "p_status" "public"."task_status", "p_result_note" "text", "p_surface" "public"."audit_surface", "p_trace_id" "text") TO "authenticated";



REVOKE ALL ON FUNCTION "public"."set_created_by"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."set_created_by"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."set_updated_at"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."set_updated_at"() TO "service_role";



REVOKE ALL ON FUNCTION "public"."tenant_id_from_stripe"("p_customer_id" "text", "p_subscription_id" "text") FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."tenant_id_from_stripe"("p_customer_id" "text", "p_subscription_id" "text") TO "service_role";



REVOKE ALL ON FUNCTION "public"."touch_updated_at"() FROM PUBLIC;
GRANT ALL ON FUNCTION "public"."touch_updated_at"() TO "service_role";



GRANT ALL ON TABLE "public"."audit_ledger" TO "service_role";



GRANT ALL ON TABLE "public"."tenants" TO "service_role";



GRANT ALL ON TABLE "public"."tool_audit_log" TO "service_role";



GRANT ALL ON TABLE "public"."approvals" TO "service_role";



GRANT ALL ON TABLE "public"."ak_cockpit_override_state" TO "service_role";



GRANT ALL ON TABLE "public"."are1_compliance_scores" TO "service_role";



GRANT ALL ON TABLE "public"."are1_directives" TO "service_role";



GRANT ALL ON TABLE "public"."are1_kill_switch" TO "service_role";



GRANT ALL ON TABLE "public"."are1_operator_intake" TO "service_role";



GRANT ALL ON TABLE "public"."audit_events" TO "service_role";



GRANT ALL ON TABLE "public"."command_events" TO "service_role";



GRANT ALL ON SEQUENCE "public"."command_events_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."deal_objections" TO "service_role";



GRANT ALL ON TABLE "public"."deals" TO "service_role";



GRANT ALL ON TABLE "public"."decision_memos" TO "service_role";



GRANT ALL ON TABLE "public"."decision_provenance" TO "service_role";



GRANT ALL ON TABLE "public"."economic_outcomes" TO "service_role";



GRANT ALL ON TABLE "public"."embeddings_index" TO "service_role";



GRANT ALL ON TABLE "public"."engine_one_memory" TO "service_role";



GRANT ALL ON SEQUENCE "public"."engine_one_memory_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."engine_one_memory_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."engine_one_memory_id_seq" TO "service_role";



GRANT ALL ON TABLE "public"."event_log" TO "service_role";



GRANT ALL ON TABLE "public"."executions" TO "service_role";



GRANT ALL ON TABLE "public"."feature_flags" TO "service_role";



GRANT ALL ON TABLE "public"."flag_proposals" TO "service_role";



GRANT ALL ON TABLE "public"."founder.founder_profile" TO "service_role";
GRANT SELECT,UPDATE ON TABLE "public"."founder.founder_profile" TO "authenticated";



GRANT ALL ON TABLE "public"."founder_state" TO "service_role";



GRANT ALL ON TABLE "public"."health_checks" TO "service_role";



GRANT ALL ON TABLE "public"."ingestion_events" TO "service_role";



GRANT ALL ON TABLE "public"."intents" TO "service_role";



GRANT ALL ON TABLE "public"."kdh_rate_limits" TO "service_role";
GRANT SELECT ON TABLE "public"."kdh_rate_limits" TO "authenticated";



GRANT ALL ON TABLE "public"."kill_switch" TO "service_role";



GRANT ALL ON TABLE "public"."messages" TO "service_role";



GRANT ALL ON TABLE "public"."mvp_messages" TO "service_role";



GRANT ALL ON TABLE "public"."mvp_thread_summaries" TO "service_role";
GRANT SELECT,INSERT,UPDATE ON TABLE "public"."mvp_thread_summaries" TO "authenticated";



GRANT ALL ON TABLE "public"."mvp_threads" TO "service_role";



GRANT ALL ON TABLE "public"."offers" TO "service_role";



GRANT ALL ON TABLE "public"."operating_doctrine" TO "service_role";



GRANT ALL ON TABLE "public"."operator_tasks" TO "service_role";



GRANT ALL ON TABLE "public"."orgs" TO "service_role";



GRANT ALL ON TABLE "public"."os_principles" TO "service_role";



GRANT ALL ON TABLE "public"."outbound_scripts" TO "service_role";



GRANT ALL ON TABLE "public"."outbound_sequences" TO "service_role";



GRANT ALL ON TABLE "public"."patterns_library" TO "service_role";



GRANT ALL ON TABLE "public"."performance_snapshots" TO "service_role";



GRANT ALL ON TABLE "public"."policy_audit_snapshots" TO "service_role";



GRANT ALL ON TABLE "public"."profiles" TO "service_role";



GRANT ALL ON TABLE "public"."proof_artifacts" TO "service_role";



GRANT ALL ON TABLE "public"."proposals" TO "service_role";



GRANT ALL ON TABLE "public"."reversals" TO "service_role";



GRANT ALL ON TABLE "public"."run_actions" TO "service_role";



GRANT ALL ON TABLE "public"."runs" TO "service_role";



GRANT ALL ON TABLE "public"."stripe_events" TO "service_role";



GRANT ALL ON TABLE "public"."task_templates" TO "service_role";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE "public"."task_templates" TO "authenticated";
GRANT SELECT ON TABLE "public"."task_templates" TO "anon";



GRANT ALL ON TABLE "public"."tasks" TO "service_role";



GRANT ALL ON TABLE "public"."tenant_members" TO "service_role";



GRANT ALL ON TABLE "public"."thread_summaries" TO "service_role";



GRANT ALL ON TABLE "public"."threads" TO "service_role";



GRANT ALL ON TABLE "public"."user_org_roles" TO "service_role";



GRANT ALL ON TABLE "public"."v_ready_to_execute" TO "service_role";



GRANT ALL ON TABLE "public"."v_receipts_index" TO "service_role";



GRANT ALL ON TABLE "public"."v_receipts_ledger" TO "service_role";



GRANT ALL ON TABLE "public"."v_run_trace" TO "service_role";



GRANT ALL ON TABLE "public"."v_run_trace_enriched" TO "service_role";



GRANT ALL ON TABLE "public"."v_runs_index" TO "service_role";



GRANT ALL ON TABLE "public"."v_user_tenants" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";







