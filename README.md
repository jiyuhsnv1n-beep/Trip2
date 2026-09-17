# 상하이 4인방 졸업여행 앱

친구들과 실시간으로 같이 보는 여행 계획 앱이에요. 한 명이 뭔가 추가/수정하면 다른 사람 화면에도 자동으로 반영돼요 (Supabase Realtime 사용).

## 1. Supabase 프로젝트 만들기 (5분)

1. https://supabase.com 접속 → 무료 회원가입 → **New project** 클릭
2. 이름, 비밀번호 아무거나 설정하고 생성 (1~2분 걸림)
3. 왼쪽 메뉴 **SQL Editor** → **New query** 클릭
4. 이 폴더의 `supabase-schema.sql` 파일 내용을 전부 복사해서 붙여넣고 **Run** 클릭
   - "trip_state 테이블 생성 완료" 같은 에러 없이 끝나면 성공
5. 왼쪽 메뉴 **Project Settings → API** 로 이동
   - **Project URL** 복사
   - **anon public** 키 복사

## 2. 앱에 연결 정보 넣기

이 폴더의 `config.js` 파일을 열어서 아래처럼 채워주세요:

```js
window.APP_CONFIG = {
  SUPABASE_URL: "https://xxxxxxxx.supabase.co",   // 1번에서 복사한 Project URL
  SUPABASE_ANON_KEY: "eyJhbGciOi...",              // 1번에서 복사한 anon public key
  TRIP_ID: "shanghai-4"                             // 그대로 둬도 됨
};
```

## 3. Vercel에 배포하기

### 방법 A: 웹사이트에서 드래그 앤 드롭 (제일 쉬움)
1. https://vercel.com 접속 → 회원가입/로그인 (깃허브 계정으로 로그인 추천)
2. 대시보드에서 **Add New → Project** → 화면 하단 **혹은** "Deploy without Git" 옵션 찾기
3. 이 폴더(`shanghai-pwa`) 전체를 압축 없이 그대로 드래그해서 올리기
   - 안 보이면: 이 폴더를 깃허브 저장소로 먼저 올린 뒤, Vercel에서 그 저장소를 Import 하는 방법이 제일 안정적이에요
4. 배포가 끝나면 `https://프로젝트이름.vercel.app` 같은 링크가 생겨요 → 이 링크를 친구들한테 공유

### 방법 B: 깃허브 + Vercel 연동 (제일 안정적, 추천)
1. 이 폴더 내용을 깃허브 새 저장소에 올리기 (`git init` → `git add .` → `git commit` → `git push`)
2. https://vercel.com → **Add New → Project** → 방금 만든 저장소 선택 → **Deploy**
   - Framework Preset: **Other** (정적 사이트라 빌드 설정 필요 없음)
3. 배포 완료 후 나온 링크를 친구들한테 공유

## 4. 스마트폰 홈 화면에 추가하기

**iOS (Safari)**
1. 배포된 링크를 Safari로 열기
2. 하단 공유 버튼 탭 → **홈 화면에 추가**

**Android (Chrome)**
1. 배포된 링크를 Chrome으로 열기
2. 오른쪽 위 점 3개 메뉴 → **앱 설치** 또는 **홈 화면에 추가**

이후로는 앱처럼 아이콘을 눌러서 바로 켤 수 있어요.

## 동작 방식 (참고)

- 모든 데이터(역할, 일정, 정산, 짐싸기 등)는 Supabase의 `trip_state` 테이블 한 행에 JSON으로 저장돼요.
- 누군가 뭔가 바꾸면 → Supabase에 저장 → Supabase가 같은 링크를 보고 있는 다른 모든 기기에 실시간으로 알려줌 → 자동으로 화면 갱신.
- 같은 링크(같은 `TRIP_ID`)를 쓰는 사람은 전부 같은 데이터를 보게 돼요. 이름 입력 같은 건 없고, 그냥 링크 하나로 다같이 씁니다.
- 동시에 같은 항목을 거의 같은 순간에 수정하면 마지막에 저장된 내용이 남아요 (친구 4명 단톡방 수준에서는 거의 문제 없어요).

## 문제 해결

- **"config.js에 Supabase URL/Key가 아직 안 채워져 있어요" 배너가 뜬다** → 2번 단계를 다시 확인하세요.
- **저장이 계속 실패한다** → Supabase 대시보드 → Table Editor에서 `trip_state` 테이블이 실제로 생성됐는지, SQL Editor에서 에러 없이 실행됐는지 확인하세요.
- **실시간 반영이 안 된다** → Supabase 대시보드 → Database → Replication 메뉴에서 `trip_state` 테이블의 Realtime이 켜져 있는지 확인하세요. (schema.sql의 마지막 줄이 이 작업을 자동으로 하지만, 안 되어 있으면 여기서 직접 토글을 켜면 됩니다.)
