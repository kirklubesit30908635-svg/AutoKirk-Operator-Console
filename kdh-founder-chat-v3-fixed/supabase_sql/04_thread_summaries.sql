-- 04_thread_summaries.sql

create table if not exists public.mvp_thread_summaries (
  thread_id uuid primary key references public.mvp_threads(id) on delete cascade,
  summary text not null default '',
  updated_at timestamptz not null default now()
);

alter table public.mvp_thread_summaries enable row level security;

drop policy if exists "founder select mvp_thread_summaries" on public.mvp_thread_summaries;
create policy "founder select mvp_thread_summaries"
on public.mvp_thread_summaries
for select
to authenticated
using (public.is_founder());

drop policy if exists "founder upsert mvp_thread_summaries" on public.mvp_thread_summaries;
create policy "founder upsert mvp_thread_summaries"
on public.mvp_thread_summaries
for insert
to authenticated
with check (public.is_founder());

drop policy if exists "founder update mvp_thread_summaries" on public.mvp_thread_summaries;
create policy "founder update mvp_thread_summaries"
on public.mvp_thread_summaries
for update
to authenticated
using (public.is_founder());
