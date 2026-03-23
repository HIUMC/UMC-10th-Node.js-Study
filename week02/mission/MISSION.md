### 진행중 미션 조회

```sql
SELECT
	m.id,
	m.point,
	m.meal_price,
	m.status,
	m.due_date,
	r.name AS restaurant_name,
	r.category,
	r.address
FROM mission m
JOIN restaurant r on r.id = m.restaurant_id
WHERE m.user_id = 1234 AND m.status = 'IN PROGRESS'
ORDER BY m.created_at DESC
LIMIT 10 OFFSET 0;
```

### 진행완료 미션 조회

```sql
SELECT
	m.id,
	m.point,
	m.status,
	m.due_date,
	r.name AS restaurant_name,
	r.category,
	r.address
	rv.id AS review_id
FROM mission m
JOIN restaurant r on r.id = m.restaurant_id
LEFT JOIN review rv ON rv.mission_id = m.id
WHERE m.user_id = 1234 AND m.status = 'COMPLETED'
ORDER BY m.created_at DESC
LIMIT 10 OFFSET 0;
```

```sql
INSERT into review (
	mission_id,
	user_id,
	restaurant_id,
	rating,
	content,
	created_at,
	updated_at,
	image_list
)
VALUES (
	1,
	1234,
	42,
	5.0,
	'음 너무 맛있어요 포인트도 얻고...',
	NOW(),
	NOW(),
	'img1.jpg','img2.jpg'
);
	
```

### 미션 달성 현황

```sql
SELECT
	COUNT(*) AS completed_count
FROM mission
WHERE user_id = 1234 AND status = 'COMPLETED'
```

### MY MISSION

```sql
SELECT
	m.id,
	r.name,
	r.category,
	m.meal_price,
	m.point,
	DATEDIFF(m.due_date, CURDATE()) AS d_day
FROM mission m
JOIN restaurant r ON r.id = m.restaurant_id
WHERE r.address LIKE '%안암동%'
AND m.user_id = 1234
AND m.status = 'BEFORE START'
AND m.due_date >= CURDATE()
ORDER BY m.due_date ASC
LIMIT 10 OFFSET 0;
```

### 마이페이지

```sql
SELECT
	u.uid,
	u.email,
	u.point,
	u.status
FROM user u
WHERE u.id = 1234;
```