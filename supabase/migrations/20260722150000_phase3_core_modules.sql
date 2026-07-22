create type public.post_kind as enum ('need', 'opportunity');
create type public.review_status as enum ('draft', 'pending_review', 'approved', 'rejected', 'closed');
create type public.evidence_kind as enum ('image', 'document', 'receipt', 'link', 'other');
create type public.event_status as enum ('draft', 'published', 'cancelled', 'completed');
create type public.report_status as enum ('open', 'reviewing', 'resolved', 'dismissed');
create type public.notification_kind as enum ('membership', 'post', 'comment', 'event', 'moderation', 'system');

create table public.community_posts (
  id uuid primary key default gen_random_uuid(),
  community_id uuid not null references public.communities(id) on delete cascade,
  author_id uuid not null references public.profiles(id) on delete cascade,
  kind public.post_kind not null,
  title text not null check (char_length(title) between 5 and 140),
  body text not null check (char_length(body) between 20 and 5000),
  location_text text check (char_length(location_text) <= 160),
  contact_preference text check (char_length(contact_preference) <= 160),
  review_status public.review_status not null default 'draft',
  reviewed_by uuid references public.profiles(id),
  reviewed_at timestamptz,
  review_note text check (char_length(review_note) <= 1000),
  closes_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.post_evidence (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references public.community_posts(id) on delete cascade,
  uploaded_by uuid not null references public.profiles(id) on delete cascade,
  kind public.evidence_kind not null default 'other',
  storage_path text,
  external_url text,
  caption text check (char_length(caption) <= 300),
  is_public boolean not null default false,
  created_at timestamptz not null default now(),
  check (storage_path is not null or external_url is not null)
);

create table public.events (
  id uuid primary key default gen_random_uuid(),
  community_id uuid not null references public.communities(id) on delete cascade,
  created_by uuid not null references public.profiles(id) on delete cascade,
  title text not null check (char_length(title) between 3 and 140),
  description text check (char_length(description) <= 5000),
  location_text text check (char_length(location_text) <= 240),
  starts_at timestamptz not null,
  ends_at timestamptz,
  capacity integer check (capacity is null or capacity > 0),
  status public.event_status not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (ends_at is null or ends_at > starts_at)
);

create table public.event_attendees (
  event_id uuid not null references public.events(id) on delete cascade,
  profile_id uuid not null references public.profiles(id) on delete cascade,
  response text not null default 'going' check (response in ('going', 'interested', 'declined')),
  created_at timestamptz not null default now(),
  primary key (event_id, profile_id)
);

create table public.comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid references public.community_posts(id) on delete cascade,
  event_id uuid references public.events(id) on delete cascade,
  author_id uuid not null references public.profiles(id) on delete cascade,
  parent_id uuid references public.comments(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 2000),
  is_hidden boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check ((post_id is not null)::integer + (event_id is not null)::integer = 1)
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  recipient_id uuid not null references public.profiles(id) on delete cascade,
  actor_id uuid references public.profiles(id) on delete set null,
  kind public.notification_kind not null,
  title text not null check (char_length(title) between 1 and 160),
  body text check (char_length(body) <= 500),
  action_url text,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  community_id uuid references public.communities(id) on delete cascade,
  post_id uuid references public.community_posts(id) on delete cascade,
  comment_id uuid references public.comments(id) on delete cascade,
  event_id uuid references public.events(id) on delete cascade,
  reason text not null check (char_length(reason) between 10 and 1000),
  status public.report_status not null default 'open',
  assigned_to uuid references public.profiles(id) on delete set null,
  resolution_note text check (char_length(resolution_note) <= 2000),
  resolved_at timestamptz,
  created_at timestamptz not null default now(),
  check (
    (community_id is not null)::integer +
    (post_id is not null)::integer +
    (comment_id is not null)::integer +
    (event_id is not null)::integer = 1
  )
);

create table public.audit_log (
  id bigint generated always as identity primary key,
  community_id uuid references public.communities(id) on delete set null,
  actor_id uuid references public.profiles(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index community_posts_feed_idx on public.community_posts (community_id, review_status, created_at desc);
create index events_schedule_idx on public.events (community_id, status, starts_at);
create index comments_post_idx on public.comments (post_id, created_at);
create index comments_event_idx on public.comments (event_id, created_at);
create index notifications_recipient_idx on public.notifications (recipient_id, read_at, created_at desc);
create index reports_status_idx on public.reports (status, created_at);

alter table public.community_posts enable row level security;
alter table public.post_evidence enable row level security;
alter table public.events enable row level security;
alter table public.event_attendees enable row level security;
alter table public.comments enable row level security;
alter table public.notifications enable row level security;
alter table public.reports enable row level security;
alter table public.audit_log enable row level security;

create or replace function public.is_active_community_member(target_community uuid)
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.community_memberships m
    where m.community_id = target_community
      and m.profile_id = auth.uid()
      and m.status = 'active'
  );
$$;

create or replace function public.is_community_moderator(target_community uuid)
returns boolean language sql stable security definer set search_path = public
as $$
  select exists (
    select 1 from public.community_memberships m
    where m.community_id = target_community
      and m.profile_id = auth.uid()
      and m.status = 'active'
      and m.role in ('owner', 'moderator')
  ) or exists (
    select 1 from public.communities c
    where c.id = target_community and c.created_by = auth.uid()
  );
$$;

create policy "approved posts are visible to community readers"
on public.community_posts for select using (
  review_status = 'approved'
  and (
    exists (select 1 from public.communities c where c.id = community_id and c.visibility = 'public')
    or public.is_active_community_member(community_id)
  )
  or author_id = auth.uid()
  or public.is_community_moderator(community_id)
);

create policy "members create posts"
on public.community_posts for insert to authenticated
with check (author_id = auth.uid() and public.is_active_community_member(community_id));

create policy "authors edit unapproved posts"
on public.community_posts for update using (
  (author_id = auth.uid() and review_status in ('draft', 'pending_review'))
  or public.is_community_moderator(community_id)
);

create policy "evidence follows post visibility"
on public.post_evidence for select using (
  uploaded_by = auth.uid()
  or exists (
    select 1 from public.community_posts p
    where p.id = post_id
      and (public.is_community_moderator(p.community_id) or (is_public and p.review_status = 'approved'))
  )
);

create policy "post authors add evidence"
on public.post_evidence for insert to authenticated
with check (
  uploaded_by = auth.uid()
  and exists (select 1 from public.community_posts p where p.id = post_id and p.author_id = auth.uid())
);

create policy "published events are readable"
on public.events for select using (
  status = 'published'
  and (
    exists (select 1 from public.communities c where c.id = community_id and c.visibility = 'public')
    or public.is_active_community_member(community_id)
  )
  or created_by = auth.uid()
  or public.is_community_moderator(community_id)
);

create policy "members create events"
on public.events for insert to authenticated
with check (created_by = auth.uid() and public.is_active_community_member(community_id));

create policy "event creators and moderators update events"
on public.events for update using (created_by = auth.uid() or public.is_community_moderator(community_id));

create policy "attendees are visible with event"
on public.event_attendees for select using (
  profile_id = auth.uid()
  or exists (select 1 from public.events e where e.id = event_id and (e.created_by = auth.uid() or public.is_community_moderator(e.community_id)))
);

create policy "users manage own attendance"
on public.event_attendees for all to authenticated
using (profile_id = auth.uid()) with check (profile_id = auth.uid());

create policy "visible comments follow visible parent"
on public.comments for select using (
  not is_hidden and (
    exists (select 1 from public.community_posts p where p.id = post_id and (p.review_status = 'approved' or p.author_id = auth.uid() or public.is_community_moderator(p.community_id)))
    or exists (select 1 from public.events e where e.id = event_id and (e.status = 'published' or e.created_by = auth.uid() or public.is_community_moderator(e.community_id)))
  )
);

create policy "members add comments"
on public.comments for insert to authenticated
with check (
  author_id = auth.uid()
  and (
    exists (select 1 from public.community_posts p where p.id = post_id and public.is_active_community_member(p.community_id))
    or exists (select 1 from public.events e where e.id = event_id and public.is_active_community_member(e.community_id))
  )
);

create policy "authors update own comments"
on public.comments for update using (author_id = auth.uid());

create policy "users read own notifications"
on public.notifications for select using (recipient_id = auth.uid());

create policy "users mark own notifications read"
on public.notifications for update using (recipient_id = auth.uid()) with check (recipient_id = auth.uid());

create policy "authenticated users submit reports"
on public.reports for insert to authenticated with check (reporter_id = auth.uid());

create policy "reporters and moderators read reports"
on public.reports for select using (
  reporter_id = auth.uid()
  or (community_id is not null and public.is_community_moderator(community_id))
  or exists (select 1 from public.community_posts p where p.id = post_id and public.is_community_moderator(p.community_id))
  or exists (select 1 from public.comments c join public.community_posts p on p.id = c.post_id where c.id = comment_id and public.is_community_moderator(p.community_id))
  or exists (select 1 from public.events e where e.id = event_id and public.is_community_moderator(e.community_id))
);

create policy "moderators update reports"
on public.reports for update using (
  (community_id is not null and public.is_community_moderator(community_id))
  or exists (select 1 from public.community_posts p where p.id = post_id and public.is_community_moderator(p.community_id))
  or exists (select 1 from public.events e where e.id = event_id and public.is_community_moderator(e.community_id))
);

create policy "moderators read audit records"
on public.audit_log for select using (community_id is not null and public.is_community_moderator(community_id));

create or replace function public.record_moderation_audit()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  if tg_table_name = 'community_posts' and old.review_status is distinct from new.review_status then
    insert into public.audit_log (community_id, actor_id, action, entity_type, entity_id, metadata)
    values (new.community_id, auth.uid(), 'review_status_changed', 'community_post', new.id,
      jsonb_build_object('from', old.review_status, 'to', new.review_status));
  elsif tg_table_name = 'reports' and old.status is distinct from new.status then
    insert into public.audit_log (community_id, actor_id, action, entity_type, entity_id, metadata)
    values (new.community_id, auth.uid(), 'report_status_changed', 'report', new.id,
      jsonb_build_object('from', old.status, 'to', new.status));
  end if;
  return new;
end;
$$;

create trigger community_posts_audit
after update on public.community_posts
for each row execute procedure public.record_moderation_audit();

create trigger reports_audit
after update on public.reports
for each row execute procedure public.record_moderation_audit();