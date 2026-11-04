-- ARC hosted persistence schema (Supabase / PostgreSQL)
create extension if not exists pgcrypto;
create table if not exists public.notes (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 title text not null default 'Untitled',
 content text not null default '',
 folder text not null default 'Personal',
 tags text[] not null default '{}',
 is_favorite boolean not null default false,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create index if not exists notes_user_updated_idx on public.notes(user_id,updated_at desc);
alter table public.notes enable row level security;
drop policy if exists "Users manage their own notes" on public.notes;
create policy "Users manage their own notes" on public.notes for all using (auth.uid()=user_id) with check (auth.uid()=user_id);
create or replace function public.set_updated_at() returns trigger language plpgsql as $$ begin new.updated_at=now(); return new; end; $$;
drop trigger if exists notes_updated_at on public.notes;
create trigger notes_updated_at before update on public.notes for each row execute procedure public.set_updated_at();