begin;

-- Additive v2 storage. Legacy website rows in learning_progress are untouched.
create table if not exists public.learning_journeys (
  user_id uuid not null references auth.users(id) on delete cascade,
  concept text not null check (concept = 'distribution'),
  session jsonb not null check (jsonb_typeof(session) = 'object' and session->>'concept' = concept and session->>'version' = '2'),
  revision integer not null check (revision > 0),
  updated_at timestamptz not null default now(),
  primary key (user_id, concept)
);

alter table public.learning_journeys enable row level security;
revoke all on public.learning_journeys from anon, authenticated;
grant all on public.learning_journeys to service_role;

create or replace function public.save_learning_journey(p_user_id uuid, p_concept text, p_expected_revision integer, p_session jsonb)
returns setof public.learning_journeys
language plpgsql security definer set search_path = '' as $$
begin
  if p_user_id is null or p_concept is distinct from 'distribution' or p_expected_revision is null or p_expected_revision < 0 or p_expected_revision >= 2147483647 or jsonb_typeof(p_session) is distinct from 'object' or p_session->>'concept' is distinct from p_concept or p_session->>'version' is distinct from '2' then
    raise exception 'invalid_journey' using errcode = 'P0001';
  end if;
  if p_expected_revision = 0 then
    return query insert into public.learning_journeys (user_id, concept, session, revision)
      values (p_user_id, p_concept, p_session, 1) on conflict (user_id, concept) do nothing returning *;
  else
    return query update public.learning_journeys set session = p_session, revision = revision + 1, updated_at = now()
      where user_id = p_user_id and concept = p_concept and revision = p_expected_revision returning *;
  end if;
  if not found then raise exception 'revision_conflict' using errcode = 'P0001'; end if;
end;
$$;
revoke all on function public.save_learning_journey(uuid, text, integer, jsonb) from public, anon, authenticated;
grant execute on function public.save_learning_journey(uuid, text, integer, jsonb) to service_role;

commit;
