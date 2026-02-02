-- 1) canonical founder source (LOCAL)
create schema if not exists founder;

create table if not exists founder.founders (
  user_id uuid primary key,
  status  text not null default 'active',
  added_at timestamptz not null default now()
);
