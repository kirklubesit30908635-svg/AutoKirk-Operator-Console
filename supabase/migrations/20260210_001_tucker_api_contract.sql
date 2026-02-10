-- TUCKER: Next Actions (law-side view)
create or replace view tucker.v_current_open_obligations as
select
  o.id,
  o.promise_id,
  o.due_at,
  o.severity
from tucker.obligations o
where o.status = 'open';

-- API contract: Next Actions (exposed via Data API)
create or replace view api.v_current_open_obligations as
select
  id,
  promise_id,
  due_at,
  severity
from tucker.v_current_open_obligations;

grant select on api.v_current_open_obligations to anon, authenticated;

-- API contract: Promise state (exposed via Data API)
create or replace view api.v_promises_state as
select * from tucker.v_promises_state;

grant select on api.v_promises_state to anon, authenticated;
