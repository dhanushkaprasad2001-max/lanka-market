-- VIKMA production hardening applied to the connected project.
-- Move admin check out of exposed public schema and optimize RLS predicates.
create schema if not exists private;
revoke all on schema private from public;
grant usage on schema private to anon, authenticated;
create or replace function private.is_lankamarket_admin()
returns boolean language sql stable security definer set search_path = '' as $$
 select exists(select 1 from public.profiles where id=(select auth.uid()) and role='admin');
$$;
revoke all on function private.is_lankamarket_admin() from public;
grant execute on function private.is_lankamarket_admin() to anon,authenticated;

-- The full policy replacement is documented in the Supabase migration
-- vikma_private_admin_rls_optimization and vikma_split_admin_policies.
-- This file records the final security architecture for repository setup.
