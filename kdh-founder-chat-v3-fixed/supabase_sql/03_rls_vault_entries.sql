-- 03_rls_vault_entries.sql

alter table public.vault_entries enable row level security;

drop policy if exists "founder select vault_entries" on public.vault_entries;
create policy "founder select vault_entries"
on public.vault_entries
for select
to authenticated
using (public.is_founder());

drop policy if exists "founder insert vault_entries" on public.vault_entries;
create policy "founder insert vault_entries"
on public.vault_entries
for insert
to authenticated
with check (public.is_founder());
