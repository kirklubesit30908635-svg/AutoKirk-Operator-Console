-- 02_rls_mvp_threads_messages.sql

alter table public.mvp_threads enable row level security;
alter table public.mvp_messages enable row level security;

-- Threads
drop policy if exists "founder select mvp_threads" on public.mvp_threads;
create policy "founder select mvp_threads"
on public.mvp_threads
for select
to authenticated
using (public.is_founder());

drop policy if exists "founder insert mvp_threads" on public.mvp_threads;
create policy "founder insert mvp_threads"
on public.mvp_threads
for insert
to authenticated
with check (public.is_founder());

-- Messages
drop policy if exists "founder select mvp_messages" on public.mvp_messages;
create policy "founder select mvp_messages"
on public.mvp_messages
for select
to authenticated
using (public.is_founder());

drop policy if exists "founder insert mvp_messages" on public.mvp_messages;
create policy "founder insert mvp_messages"
on public.mvp_messages
for insert
to authenticated
with check (public.is_founder());
