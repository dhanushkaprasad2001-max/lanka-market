-- VIKMA monetization: featured listing requests and business/banner ad enquiries.
-- This migration has already been applied to the connected Supabase project.
alter table public.listings add column if not exists featured_until timestamptz;

create table if not exists public.monetization_requests (
  id uuid primary key default gen_random_uuid(),
  requester_id uuid not null references auth.users(id) on delete cascade,
  request_type text not null check (request_type in ('featured','business','banner')),
  listing_id uuid references public.listings(id) on delete cascade,
  plan_code text not null check (plan_code in ('featured_7d','featured_30d','business_30d','banner_7d')),
  amount_lkr integer not null check (amount_lkr > 0),
  duration_days integer not null check (duration_days > 0),
  business_name text,
  contact_phone text not null,
  payment_reference text,
  message text,
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  admin_note text,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz,
  constraint monetization_plan_amount check (
    (plan_code='featured_7d' and request_type='featured' and amount_lkr=500 and duration_days=7) or
    (plan_code='featured_30d' and request_type='featured' and amount_lkr=1500 and duration_days=30) or
    (plan_code='business_30d' and request_type='business' and amount_lkr=2500 and duration_days=30) or
    (plan_code='banner_7d' and request_type='banner' and amount_lkr=3000 and duration_days=7)
  ),
  constraint monetization_listing_requirement check (
    (request_type='featured' and listing_id is not null) or
    (request_type in ('business','banner') and listing_id is null)
  )
);
create index if not exists monetization_requests_owner_idx on public.monetization_requests(requester_id,created_at desc);
create index if not exists monetization_requests_status_idx on public.monetization_requests(status,created_at desc);
alter table public.monetization_requests enable row level security;
drop policy if exists "Users read own monetization requests" on public.monetization_requests;
create policy "Users read own monetization requests" on public.monetization_requests
for select to authenticated using (requester_id=(select auth.uid()) or private.is_lankamarket_admin());
drop policy if exists "Users create own monetization requests" on public.monetization_requests;
create policy "Users create own monetization requests" on public.monetization_requests
for insert to authenticated with check (
 requester_id=(select auth.uid()) and
 (request_type<>'featured' or exists(select 1 from public.listings l where l.id=listing_id and l.user_id=(select auth.uid()) and l.status='approved'))
);
drop policy if exists "Admins review monetization requests" on public.monetization_requests;
create policy "Admins review monetization requests" on public.monetization_requests
for update to authenticated using (private.is_lankamarket_admin()) with check (private.is_lankamarket_admin());
create or replace function public.apply_vikma_monetization_decision()
returns trigger language plpgsql security definer set search_path=public as $$
begin
 if new.status is distinct from old.status then
   new.reviewed_at:=now();
   if new.status='approved' and new.request_type='featured' then
     update public.listings set featured_until=greatest(coalesce(featured_until,now()),now())+make_interval(days=>new.duration_days)
     where id=new.listing_id and user_id=new.requester_id and status='approved';
     if not found then raise exception 'The listing is no longer eligible for promotion'; end if;
   end if;
 end if;
 return new;
end; $$;
revoke all on function public.apply_vikma_monetization_decision() from public,anon,authenticated;
drop trigger if exists apply_vikma_monetization_decision_trigger on public.monetization_requests;
create trigger apply_vikma_monetization_decision_trigger before update of status on public.monetization_requests
for each row execute function public.apply_vikma_monetization_decision();
