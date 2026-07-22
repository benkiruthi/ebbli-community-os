create type public.verification_kind as enum ('person', 'organization', 'community_leader');
create type public.verification_status as enum ('draft', 'submitted', 'under_review', 'approved', 'rejected', 'expired', 'revoked');
create type public.trust_signal_kind as enum ('endorsement', 'successful_help', 'event_attendance', 'moderation_penalty', 'verification');
create type public.appeal_status as enum ('submitted', 'under_review', 'upheld', 'overturned', 'withdrawn');
create type public.ai_risk_level as enum ('low', 'medium', 'high', 'critical');
create type public.ai_review_status as enum ('not_required', 'pending', 'approved', 'rejected');

create table public.verification_requests (
  id uuid primary key default gen_random_uuid(),
  requester_id uuid not null references public.profiles(id) on delete cascade,
  community_id uuid references public.communities(id) on delete cascade,
  kind public.verification_kind not null,
  status public.verification_status not null default 'draft',
  legal_name text,
  organization_name text,
  evidence_summary text check (char_length(evidence_summary) <= 2000),
  submitted_at timestamptz,
  reviewed_at timestamptz,
  reviewed_by uuid references public.profiles(id),
  decision_reason text check (char_length(decision_reason) <= 2000),
  expires_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check ((kind = 'organization' and organization_name is not null) or kind <> 'organization')
);

create table public.verification_evidence (
  id uuid primary key default gen_random_uuid(),
  verification_request_id uuid not null references public.verification_requests(id) on delete cascade,
  storage_path text not null,
  media_type text not null,
  sha256 text,
  redacted boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.trust_signals (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references public.profiles(id) on delete cascade,
  community_id uuid references public.communities(id) on delete cascade,
  kind public.trust_signal_kind not null,
  weight smallint not null check (weight between -100 and 100),
  source_type text not null,
  source_id uuid,
  explanation text not null check (char_length(explanation) <= 500),
  created_by uuid references public.profiles(id),
  created_at timestamptz not null default now()
);

create table public.profile_trust_summaries (
  profile_id uuid primary key references public.profiles(id) on delete cascade,
  score integer not null default 0 check (score between -1000 and 1000),
  verification_level smallint not null default 0 check (verification_level between 0 and 3),
  signal_count integer not null default 0,
  last_calculated_at timestamptz not null default now()
);

create table public.moderation_appeals (
  id uuid primary key default gen_random_uuid(),
  moderation_action_id uuid not null,
  appellant_id uuid not null references public.profiles(id) on delete cascade,
  status public.appeal_status not null default 'submitted',
  reason text not null check (char_length(reason) between 20 and 3000),
  reviewer_id uuid references public.profiles(id),
  decision_reason text check (char_length(decision_reason) <= 3000),
  submitted_at timestamptz not null default now(),
  reviewed_at timestamptz,
  unique (moderation_action_id, appellant_id)
);

create table public.ai_assistance_runs (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid references public.profiles(id) on delete set null,
  community_id uuid references public.communities(id) on delete cascade,
  purpose text not null,
  model_provider text not null,
  model_name text not null,
  prompt_version text not null,
  risk_level public.ai_risk_level not null,
  confidence numeric(4,3) check (confidence between 0 and 1),
  uncertainty_note text,
  user_visible_disclaimer text,
  human_review_status public.ai_review_status not null default 'not_required',
  human_reviewer_id uuid references public.profiles(id),
  safety_flags jsonb not null default '[]'::jsonb,
  input_hash text,
  output_hash text,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz
);

alter table public.verification_requests enable row level security;
alter table public.verification_evidence enable row level security;
alter table public.trust_signals enable row level security;
alter table public.profile_trust_summaries enable row level security;
alter table public.moderation_appeals enable row level security;
alter table public.ai_assistance_runs enable row level security;

create policy "requesters read own verification requests"
on public.verification_requests for select
using (requester_id = auth.uid() or public.is_community_moderator(community_id));

create policy "requesters create verification requests"
on public.verification_requests for insert to authenticated
with check (requester_id = auth.uid());

create policy "requesters edit draft verification requests"
on public.verification_requests for update to authenticated
using (requester_id = auth.uid() and status in ('draft', 'rejected'))
with check (requester_id = auth.uid());

create policy "moderators review verification requests"
on public.verification_requests for update to authenticated
using (community_id is not null and public.is_community_moderator(community_id));

create policy "verification evidence follows request access"
on public.verification_evidence for select
using (exists (
  select 1 from public.verification_requests v
  where v.id = verification_request_id
    and (v.requester_id = auth.uid() or public.is_community_moderator(v.community_id))
));

create policy "requesters add verification evidence"
on public.verification_evidence for insert to authenticated
with check (exists (
  select 1 from public.verification_requests v
  where v.id = verification_request_id
    and v.requester_id = auth.uid()
    and v.status in ('draft', 'rejected')
));

create policy "public trust summaries are readable"
on public.profile_trust_summaries for select using (true);

create policy "members read own trust signals"
on public.trust_signals for select
using (profile_id = auth.uid() or (community_id is not null and public.is_community_moderator(community_id)));

create policy "moderators create trust signals"
on public.trust_signals for insert to authenticated
with check (community_id is not null and public.is_community_moderator(community_id));

create policy "appellants read own appeals"
on public.moderation_appeals for select
using (appellant_id = auth.uid() or reviewer_id = auth.uid());

create policy "members submit own appeals"
on public.moderation_appeals for insert to authenticated
with check (appellant_id = auth.uid());

create policy "reviewers decide assigned appeals"
on public.moderation_appeals for update to authenticated
using (reviewer_id = auth.uid());

create policy "users read own AI runs"
on public.ai_assistance_runs for select
using (profile_id = auth.uid() or (community_id is not null and public.is_community_moderator(community_id)));

create or replace function public.recalculate_profile_trust(target_profile_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profile_trust_summaries (profile_id, score, verification_level, signal_count, last_calculated_at)
  select
    target_profile_id,
    greatest(-1000, least(1000, coalesce(sum(weight), 0)::integer)),
    case
      when exists (select 1 from public.verification_requests where requester_id = target_profile_id and status = 'approved' and kind = 'organization') then 3
      when exists (select 1 from public.verification_requests where requester_id = target_profile_id and status = 'approved') then 2
      else 0
    end,
    count(*)::integer,
    now()
  from public.trust_signals
  where profile_id = target_profile_id
  on conflict (profile_id) do update set
    score = excluded.score,
    verification_level = excluded.verification_level,
    signal_count = excluded.signal_count,
    last_calculated_at = excluded.last_calculated_at;
end;
$$;

create or replace function public.sync_trust_summary()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  perform public.recalculate_profile_trust(coalesce(new.profile_id, old.profile_id));
  return coalesce(new, old);
end;
$$;

create trigger trust_signal_summary_sync
after insert or update or delete on public.trust_signals
for each row execute procedure public.sync_trust_summary();
