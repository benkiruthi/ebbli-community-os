create extension if not exists pgcrypto;

create type public.community_visibility as enum ('public', 'private');
create type public.membership_role as enum ('member', 'moderator', 'owner');
create type public.membership_status as enum ('pending', 'active', 'suspended');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null check (char_length(display_name) between 2 and 80),
  bio text check (char_length(bio) <= 500),
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.communities (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9-]{3,60}$'),
  name text not null check (char_length(name) between 3 and 100),
  description text check (char_length(description) <= 1000),
  visibility public.community_visibility not null default 'public',
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.community_memberships (
  community_id uuid not null references public.communities(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  role public.membership_role not null default 'member',
  status public.membership_status not null default 'pending',
  joined_at timestamptz,
  created_at timestamptz not null default now(),
  primary key (community_id, profile_id)
);

alter table public.profiles enable row level security;
alter table public.communities enable row level security;
alter table public.community_memberships enable row level security;

create policy "profiles are publicly readable"
on public.profiles for select using (true);

create policy "users create their own profile"
on public.profiles for insert with check (auth.uid() = id);

create policy "users update their own profile"
on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);

create policy "public communities are readable"
on public.communities for select using (
  visibility = 'public'
  or created_by = auth.uid()
  or exists (
    select 1 from public.community_memberships m
    where m.community_id = id and m.profile_id = auth.uid() and m.status = 'active'
  )
);

create policy "authenticated users create communities"
on public.communities for insert to authenticated
with check (created_by = auth.uid());

create policy "owners update communities"
on public.communities for update using (
  created_by = auth.uid()
  or exists (
    select 1 from public.community_memberships m
    where m.community_id = id and m.profile_id = auth.uid() and m.role = 'owner' and m.status = 'active'
  )
);

create policy "memberships visible to self and community moderators"
on public.community_memberships for select using (
  profile_id = auth.uid()
  or exists (
    select 1 from public.community_memberships viewer
    where viewer.community_id = community_id
      and viewer.profile_id = auth.uid()
      and viewer.role in ('owner', 'moderator')
      and viewer.status = 'active'
  )
);

create policy "users request membership"
on public.community_memberships for insert to authenticated
with check (profile_id = auth.uid() and role = 'member');

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'display_name', split_part(new.email, '@', 1)));
  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();
