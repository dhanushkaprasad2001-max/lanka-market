-- VIKMA buyer-seller messaging
-- Applied to the connected Supabase project. Safe to re-run.
create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.listings(id) on delete cascade,
  buyer_id uuid not null references auth.users(id) on delete cascade,
  seller_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  last_message_at timestamptz not null default now(),
  constraint conversations_distinct_users check (buyer_id <> seller_id),
  constraint conversations_unique_buyer_listing unique (listing_id, buyer_id)
);
create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 3000),
  created_at timestamptz not null default now()
);
create index if not exists conversations_buyer_recent_idx on public.conversations (buyer_id, last_message_at desc);
create index if not exists conversations_seller_recent_idx on public.conversations (seller_id, last_message_at desc);
create index if not exists messages_conversation_recent_idx on public.messages (conversation_id, created_at);
create index if not exists messages_sender_id_idx on public.messages (sender_id);
alter table public.conversations enable row level security;
alter table public.messages enable row level security;
drop policy if exists "Conversation participants can read" on public.conversations;
create policy "Conversation participants can read" on public.conversations for select to authenticated
using (buyer_id = (select auth.uid()) or seller_id = (select auth.uid()));
drop policy if exists "Buyer starts conversation with listing owner" on public.conversations;
create policy "Buyer starts conversation with listing owner" on public.conversations for insert to authenticated
with check (buyer_id = (select auth.uid()) and buyer_id <> seller_id and exists (
  select 1 from public.listings l where l.id = listing_id and l.user_id = seller_id and l.status = 'approved'
));
drop policy if exists "Conversation participants read messages" on public.messages;
create policy "Conversation participants read messages" on public.messages for select to authenticated
using (exists (select 1 from public.conversations c where c.id = conversation_id
  and ((select auth.uid()) = c.buyer_id or (select auth.uid()) = c.seller_id)));
drop policy if exists "Participants send messages as themselves" on public.messages;
create policy "Participants send messages as themselves" on public.messages for insert to authenticated
with check (sender_id = (select auth.uid()) and exists (
  select 1 from public.conversations c where c.id = conversation_id
  and ((select auth.uid()) = c.buyer_id or (select auth.uid()) = c.seller_id)
));
create or replace function public.vikma_touch_conversation()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  update public.conversations set last_message_at = new.created_at
  where id = new.conversation_id and (buyer_id = auth.uid() or seller_id = auth.uid());
  return new;
end;
$$;
revoke all on function public.vikma_touch_conversation() from public, anon, authenticated;
drop trigger if exists vikma_touch_conversation_after_message on public.messages;
create trigger vikma_touch_conversation_after_message after insert on public.messages
for each row execute function public.vikma_touch_conversation();
