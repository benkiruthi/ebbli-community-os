begin;

create extension if not exists pgtap with schema extensions;

select plan(15);

select tables_are(
  'public',
  array[
    'ai_assistance_runs',
    'audit_log',
    'comments',
    'communities',
    'community_memberships',
    'community_posts',
    'event_attendees',
    'events',
    'moderation_appeals',
    'notifications',
    'post_evidence',
    'profile_trust_summaries',
    'profiles',
    'reports',
    'trust_signals',
    'verification_evidence',
    'verification_requests'
  ],
  'expected public application tables exist'
);

select results_eq(
  $$select count(*)::bigint
    from pg_class
    where relnamespace = 'public'::regnamespace
      and relkind = 'r'
      and relname = any(array[
        'ai_assistance_runs', 'audit_log', 'comments', 'communities',
        'community_memberships', 'community_posts', 'event_attendees', 'events',
        'moderation_appeals', 'notifications', 'post_evidence',
        'profile_trust_summaries', 'profiles', 'reports', 'trust_signals',
        'verification_evidence', 'verification_requests'
      ])
      and relrowsecurity$$,
  array[17::bigint],
  'RLS is enabled on every application table'
);

select function_privs_are(
  'public',
  'recalculate_profile_trust',
  array['uuid'],
  'authenticated',
  array[]::text[],
  'authenticated cannot execute privileged trust recalculation'
);

select function_privs_are(
  'public',
  'record_moderation_audit',
  array[]::text[],
  'authenticated',
  array[]::text[],
  'authenticated cannot directly execute the moderation audit trigger'
);

insert into auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
) values
  (
    '00000000-0000-0000-0000-000000000000',
    '11111111-1111-4111-8111-111111111111',
    'authenticated',
    'authenticated',
    'owner@example.test',
    crypt('test-password', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"display_name":"Owner"}',
    now(),
    now()
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '22222222-2222-4222-8222-222222222222',
    'authenticated',
    'authenticated',
    'member@example.test',
    crypt('test-password', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"display_name":"Member"}',
    now(),
    now()
  );

insert into public.communities (id, slug, name, created_by)
values (
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  'audit-community',
  'Audit Community',
  '11111111-1111-4111-8111-111111111111'
);

insert into public.community_memberships (community_id, profile_id, role, status, joined_at)
values
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
    '11111111-1111-4111-8111-111111111111',
    'owner',
    'active',
    now()
  ),
  (
    'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
    '22222222-2222-4222-8222-222222222222',
    'member',
    'active',
    now()
  );

insert into public.verification_requests (
  id,
  requester_id,
  community_id,
  kind,
  status
) values (
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
  '22222222-2222-4222-8222-222222222222',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  'person',
  'draft'
);

insert into public.community_posts (
  id,
  community_id,
  author_id,
  kind,
  title,
  body
) values (
  'cccccccc-cccc-4ccc-8ccc-cccccccccccc',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  '22222222-2222-4222-8222-222222222222',
  'need',
  'Test need',
  'Test body with enough content for validation'
);

set local role authenticated;
set local request.jwt.claim.sub = '22222222-2222-4222-8222-222222222222';
set local request.jwt.claim.role = 'authenticated';

select is(
  (select count(*) from public.verification_requests),
  1::bigint,
  'requester can read their verification request'
);

select throws_ok(
  $$update public.verification_requests
    set status = 'approved', reviewed_by = '22222222-2222-4222-8222-222222222222'
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  'P0001',
  'requesters cannot write review decisions',
  'requester cannot self-approve verification'
);

select lives_ok(
  $$update public.verification_requests
    set status = 'submitted', submitted_at = now()
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  'requester can submit a draft verification request'
);

select throws_ok(
  $$update public.community_posts
    set author_id = '11111111-1111-4111-8111-111111111111'
    where id = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc'$$,
  'P0001',
  'post ownership and tenant fields are immutable',
  'post author cannot transfer ownership'
);

select throws_ok(
  $$update public.community_posts
    set review_status = 'approved'
    where id = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc'$$,
  'P0001',
  'authors cannot approve, reject, or close posts',
  'post author cannot approve their own post'
);

select is(
  (select count(*) from public.audit_log),
  0::bigint,
  'denied post updates do not create audit records'
);

set local request.jwt.claim.sub = '11111111-1111-4111-8111-111111111111';

select lives_ok(
  $$update public.community_posts
    set review_status = 'approved'
    where id = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc'$$,
  'community owner can approve a post'
);

select is(
  (select count(*) from public.audit_log where action = 'review_status_changed'),
  1::bigint,
  'approved post transition creates one audit record'
);

set local request.jwt.claim.sub = '22222222-2222-4222-8222-222222222222';

select is(
  (select count(*) from public.audit_log),
  0::bigint,
  'ordinary member cannot read moderation audit records'
);

set local role anon;
set local request.jwt.claim.sub = '';
set local request.jwt.claim.role = 'anon';

select is(
  (select count(*) from public.verification_requests),
  0::bigint,
  'anonymous users cannot read verification requests'
);

select is(
  (select count(*) from public.community_memberships),
  0::bigint,
  'anonymous users cannot read private membership rows'
);

select * from finish();
rollback;
