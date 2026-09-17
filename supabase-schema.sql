-- ============================================================
-- 상하이 졸업여행 앱: Supabase 테이블 세팅 스크립트
-- Supabase 대시보드 → SQL Editor → New query 에 붙여넣고 실행하세요.
-- ============================================================

-- 1. 상태를 통째로 저장할 테이블 (한 여행 = 한 행)
create table if not exists public.trip_state (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

-- 2. Row Level Security 켜기
alter table public.trip_state enable row level security;

-- 3. 친구들끼리만 쓰는 앱이라, anon key로 누구나 읽고 쓸 수 있게 열어둠
--    (더 엄격하게 하고 싶으면 이 정책들을 수정하세요)
drop policy if exists "trip_state_select" on public.trip_state;
create policy "trip_state_select" on public.trip_state
  for select using (true);

drop policy if exists "trip_state_insert" on public.trip_state;
create policy "trip_state_insert" on public.trip_state
  for insert with check (true);

drop policy if exists "trip_state_update" on public.trip_state;
create policy "trip_state_update" on public.trip_state
  for update using (true);

-- 4. 실시간(Realtime) 반영을 위해 publication에 테이블 추가
--    이미 추가되어 있으면 에러가 나도 무시해도 됩니다.
alter publication supabase_realtime add table public.trip_state;

-- ============================================================
-- 완료! 이제 Supabase 대시보드 → Table Editor에서
-- trip_state 테이블이 보이면 성공입니다.
--
-- 다음: Project Settings → API 에서
--   - Project URL
--   - anon public key
-- 를 복사해서 config.js에 붙여넣으세요.
-- ============================================================
