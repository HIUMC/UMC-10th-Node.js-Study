-- 1번

SELECT 
    mm.id AS member_mission_id,
    mm.status,
    s.name AS store_name,
    s.address AS store_address,
    m.mission_spec,
    m.reward,
    m.deadline,
    mm.created_at
FROM member_mission AS mm
JOIN mission AS m ON mm.mission_id = m.id
JOIN store AS s ON m.store_id = s.id
WHERE mm.member_id = :my_id
  AND mm.status IN ('진행중', '진행완료')
  AND mm.created_at < :last_created_at
ORDER BY mm.created_at DESC
LIMIT 15;

-- 2번

INSERT INTO review (member_id, store_id, body, score)
VALUES (:member_id, :store_id, :body, :score);

-- 3번

SELECT
    m.id AS mission_id,
    s.name AS store_name,
    s.address AS store_address,
    s.score AS store_score,
    m.mission_spec,
    m.reward,
    m.deadline
FROM mission AS m
JOIN store AS s
    ON m.store_id = s.id
WHERE s.region_id = :region_id       
  AND m.deadline > NOW()             
  AND NOT EXISTS (                
      SELECT 1
      FROM member_mission AS mm
      WHERE mm.mission_id = m.id
        AND mm.member_id = :my_id
  )
ORDER BY m.deadline ASC            
LIMIT 15 OFFSET :offset;

-- 4번

SELECT
    m.id,
    m.name,
    m.email,
    m.gender,
    m.age,
    m.address,
    m.social_type,
    m.point,
    COUNT(DISTINCT r.id) AS review_count,
    COUNT(DISTINCT mm.id) AS mission_count
FROM member AS m
LEFT JOIN review AS r ON m.id = r.member_id
LEFT JOIN member_mission AS mm
       ON m.id = mm.member_id
      AND mm.status = '진행완료'
WHERE m.id = :my_id
GROUP BY m.id;