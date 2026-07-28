-- Harden workflow integrity and function execution without rewriting published migrations.

-- Supabase projects created after the 2026 Data API change require explicit table grants.
-- RLS remains the authorization boundary after these API-level privileges are granted.
grant usage on schema public to anon, authenticated;
grant select on all tables in schema public to anon, authenticated;
grant insert, update, delete on all tables in schema public to authenticated;

-- Replace the self-referencing membership policy with the hardened helper to avoid RLS
-- recursion while preserving self and moderator visibility.
drop policy if exists "memberships visible to self and community moderators"
on public.community_memberships;

create policy "memberships visible to self and community moderators"
on public.community_memberships
for select
to anon, authenticated
using (
  profile_id = (select auth.uid())
  or public.is_community_moderator(community_id)
);

create or replace function public.enforce_community_post_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.author_id is distinct from old.author_id
    or new.community_id is distinct from old.community_id
    or new.kind is distinct from old.kind then
    raise exception 'post ownership and tenant fields are immutable';
  end if;

  if (select auth.uid()) = old.author_id
    and not public.is_community_moderator(old.community_id)
    and new.review_status not in ('draft', 'pending_review') then
    raise exception 'authors cannot approve, reject, or close posts';
  end if;

  return new;
end;
$$;

create trigger enforce_community_post_update
before update on public.community_posts
for each row execute procedure public.enforce_community_post_update();

create or replace function public.enforce_event_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.created_by is distinct from old.created_by
    or new.community_id is distinct from old.community_id then
    raise exception 'event ownership and tenant fields are immutable';
  end if;
  return new;
end;
$$;

create trigger enforce_event_update
before update on public.events
for each row execute procedure public.enforce_event_update();

create or replace function public.enforce_comment_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.author_id is distinct from old.author_id
    or new.post_id is distinct from old.post_id
    or new.event_id is distinct from old.event_id
    or new.parent_id is distinct from old.parent_id then
    raise exception 'comment ownership and parent fields are immutable';
  end if;

  if new.is_hidden is distinct from old.is_hidden then
    raise exception 'comment authors cannot change moderation state';
  end if;
  return new;
end;
$$;

create trigger enforce_comment_update
before update on public.comments
for each row execute procedure public.enforce_comment_update();

create or replace function public.enforce_report_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.reporter_id is distinct from old.reporter_id
    or new.community_id is distinct from old.community_id
    or new.post_id is distinct from old.post_id
    or new.comment_id is distinct from old.comment_id
    or new.event_id is distinct from old.event_id then
    raise exception 'report ownership and target fields are immutable';
  end if;
  return new;
end;
$$;

create trigger enforce_report_update
before update on public.reports
for each row execute procedure public.enforce_report_update();

drop policy if exists "requesters edit draft verification requests"
on public.verification_requests;

create policy "requesters edit draft verification requests"
on public.verification_requests
for update
to authenticated
using (
  requester_id = (select auth.uid())
  and status in ('draft', 'rejected')
)
with check (
  requester_id = (select auth.uid())
  and status in ('draft', 'submitted')
  and reviewed_at is null
  and reviewed_by is null
  and decision_reason is null
  and expires_at is null
);

create or replace function public.enforce_verification_request_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.requester_id is distinct from old.requester_id
    or new.community_id is distinct from old.community_id
    or new.kind is distinct from old.kind then
    raise exception 'verification ownership, tenant, and kind are immutable';
  end if;

  if (select auth.uid()) = old.requester_id
    and not public.is_community_moderator(old.community_id)
    and (
      new.status not in ('draft', 'submitted')
      or new.reviewed_at is not null
      or new.reviewed_by is not null
      or new.decision_reason is not null
      or new.expires_at is not null
    ) then
    raise exception 'requesters cannot write review decisions';
  end if;

  return new;
end;
$$;

create trigger enforce_verification_request_update
before update on public.verification_requests
for each row execute procedure public.enforce_verification_request_update();

create or replace function public.enforce_appeal_update()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.moderation_action_id is distinct from old.moderation_action_id
    or new.appellant_id is distinct from old.appellant_id
    or new.reviewer_id is distinct from old.reviewer_id
    or new.reason is distinct from old.reason
    or new.submitted_at is distinct from old.submitted_at then
    raise exception 'appeal identity, assignment, and submission are immutable';
  end if;
  return new;
end;
$$;

create trigger enforce_appeal_update
before update on public.moderation_appeals
for each row execute procedure public.enforce_appeal_update();

-- Trigger functions are not public APIs.
revoke all on function public.handle_new_user() from public, anon, authenticated;
revoke all on function public.record_moderation_audit() from public, anon, authenticated;
revoke all on function public.sync_trust_summary() from public, anon, authenticated;
revoke all on function public.enforce_community_post_update() from public, anon, authenticated;
revoke all on function public.enforce_event_update() from public, anon, authenticated;
revoke all on function public.enforce_comment_update() from public, anon, authenticated;
revoke all on function public.enforce_report_update() from public, anon, authenticated;
revoke all on function public.enforce_verification_request_update() from public, anon, authenticated;
revoke all on function public.enforce_appeal_update() from public, anon, authenticated;

-- Policy helpers are available only to signed-in users.
revoke all on function public.is_active_community_member(uuid) from public;
revoke all on function public.is_community_moderator(uuid) from public;
grant execute on function public.is_active_community_member(uuid) to anon, authenticated;
grant execute on function public.is_community_moderator(uuid) to anon, authenticated;

-- Trust summaries are maintained by the trigger, never directly by API callers.
revoke all on function public.recalculate_profile_trust(uuid) from public, anon, authenticated;
