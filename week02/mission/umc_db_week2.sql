-- =============================================
-- UMC 2주차 미션 쿼리
-- =============================================

-- =============================================
-- 1. 내가 진행중/진행 완료한 미션 목록 조회 (페이징 포함)
-- =============================================
-- 화면: 미션 탭 - 진행중/진행완료 탭으로 나뉨
-- 페이징: LIMIT(한 페이지에 보여줄 개수), OFFSET(몇 번째부터 보여줄지)

SELECT
    um.id               AS user_mission_id,
    s.name              AS store_name,
    m.title             AS mission_title,
    m.point_reward      AS point,
    um.status           AS mission_status,
    um.started_at,
    um.completed_at
FROM user_mission um
JOIN mission m ON um.mission_id = m.id
JOIN store s   ON m.store_id = s.id
WHERE um.user_id = 1                  -- 로그인한 유저 id
  AND um.status = 'CHALLENGING'       -- 진행중: 'CHALLENGING' / 진행완료: 'COMPLETE'
ORDER BY um.started_at DESC
LIMIT 10 OFFSET 0;                    -- 1페이지: OFFSET 0, 2페이지: OFFSET 10

-- 진행완료 탭으로 바꿀 때는 status 조건만 변경
-- AND um.status = 'COMPLETE'


-- =============================================
-- 2. 리뷰 작성 쿼리 (사진 제외)
-- =============================================
-- 화면: 미션 완료 후 리뷰 작성
-- 조건: 미션이 COMPLETE 상태일 때만 리뷰 작성 가능
--       한 미션당 리뷰 1개만 작성 가능 (review 테이블에 user_mission_id UNIQUE 설정)

INSERT INTO review (
    user_id,
    store_id,
    user_mission_id,
    body,
    score
)
SELECT
    um.user_id,
    m.store_id,
    um.id,
    '너무 맛있어요! 포인트도 받고 좋았습니다.',   -- 실제로는 유저가 입력한 내용
    4.5                                            -- 실제로는 유저가 선택한 별점
FROM user_mission um
JOIN mission m ON um.mission_id = m.id
WHERE um.id = 1                    -- 리뷰 작성할 user_mission id
  AND um.user_id = 1               -- 로그인한 유저 id (본인 미션만 작성 가능)
  AND um.status = 'COMPLETE';      -- 완료된 미션만 리뷰 작성 가능

-- 리뷰 작성 후 해당 가게의 평균 별점 업데이트
UPDATE store s
SET score = (
    SELECT AVG(r.score)
    FROM review r
    WHERE r.store_id = s.id
)
WHERE s.id = (
    SELECT m.store_id
    FROM user_mission um
    JOIN mission m ON um.mission_id = m.id
    WHERE um.id = 1               -- 방금 리뷰 작성한 user_mission id
);


-- =============================================
-- 3. 홈 화면 - 현재 선택된 지역에서 도전 가능한 미션 목록 (페이징 포함)
-- =============================================
-- 화면: 홈 탭 - 선택된 지역(예: 안암동)의 미션 목록
-- 조건: 아직 내가 도전하지 않은 미션 or 현재 지역의 전체 미션
-- 상단: 현재 지역에서 내가 완료한 미션 수 / 10 표시

-- 현재 지역 완료 미션 수 (상단 7/10 표시용)
SELECT COUNT(*) AS complete_count
FROM user_mission um
JOIN mission m ON um.mission_id = m.id
JOIN store s   ON m.store_id = s.id
WHERE um.user_id = 1              -- 로그인한 유저 id
  AND s.region_id = 1            -- 현재 선택된 지역 id
  AND um.status = 'COMPLETE';

-- 현재 지역에서 도전 가능한 미션 목록 (아직 도전 안 한 미션)
SELECT
    m.id            AS mission_id,
    s.name          AS store_name,
    fc.name         AS category,
    m.title         AS mission_title,
    m.point_reward  AS point,
    m.deadline
FROM mission m
JOIN store s            ON m.store_id = s.id
JOIN food_category fc   ON s.food_category_id = fc.id
WHERE s.region_id = 1                          -- 현재 선택된 지역 id
  AND s.status = 'OPEN'
  AND m.id NOT IN (                            -- 내가 이미 도전중이거나 완료한 미션 제외
      SELECT mission_id
      FROM user_mission
      WHERE user_id = 1                        -- 로그인한 유저 id
  )
ORDER BY m.created_at DESC
LIMIT 10 OFFSET 0;                             -- 1페이지: OFFSET 0, 2페이지: OFFSET 10


-- =============================================
-- 4. 마이페이지 화면 쿼리
-- =============================================
-- 화면: 닉네임, 이메일, 휴대폰번호, 내 포인트, 작성한 리뷰 수

SELECT
    u.nickname,
    u.email,
    u.phone,
    u.profile_img,
    u.point,
    COUNT(r.id) AS review_count        -- 작성한 리뷰 수
FROM user u
LEFT JOIN review r ON r.user_id = u.id
WHERE u.id = 1                         -- 로그인한 유저 id
GROUP BY u.id;
