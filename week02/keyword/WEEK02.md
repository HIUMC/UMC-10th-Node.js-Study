# 🔮 실전 SQL - 워밍업

## 1. 기본 조회

### JOIN

---

ERD에서 연결된 테이블을 합칠 때 쓴다고 생각

```sql
SELECT 컬럼
FROM A테이블
JOIN B테이블 ON A테이블.fk = B테이블.id
```

<aside>
🔑 “소설” 카테고리의 모든 책을 조회하자.

</aside>

```sql
SELECT book.name, book.discription
FROM book
JOIN book_category ON book.book_category_id = book_category.id
WHERE book_category.name = "소설"
```

## 2. 집계 함수

- `COUNT (*)` : 행 개수
- `SUM (컬럼)` : 합계
- `AVG (컬럼)` : 평균
- `MAX (컬럼)` : 최댓값
- `MIN (컬럼)` : 최솟값

```sql
SELECT 그룹기준컬럼, 집계함수
FROM 테이블
GROUP BY 그룹기준컬럼
```

<aside>
🔑 회원별 대여 횟수 상위 5명을 조회하자.

</aside>

```sql
SELECT member.name, COUNT(*) as rent_count
FROM member
JOIN rent ON member.id = rent.member_id
GROUP BY member.id, member.name
ORDER BY rent_count DESC
LIMIT 5
```

## 3. 복합 JOIN

<aside>
🔑 각 회원이 좋아요를 누른 책의 카테고리별 분포를 조회하자.

</aside>

```sql
SELECT m.name, bc.name as category, COUNT(*) as like_count
FROM member m
JOIN book_likes bl ON m.id=bl.member_id
JOIN book b ON bl.book_id=b.id
JOIN book_category bc on b.book_category_id=bc.id
GROUP BY m.id, m.name, bc.id, bc.name
```

JOIN이 여러개일 때는 ERD의 선을 따라가면 됨

## 4. 서브쿼리

<aside>
🔑 각 회원이 좋아요를 누른 책의 카테고리별 분포를 조회하자.

</aside>

```sql
SELECT m.name, bc.name as category, 
( SELECT COUNT(*) 
FROM book_likes bl 
JOIN book b ON bl.book_id=b.id 
WHERE bl.member_id = m.id AND b.book_category_id=bc.id) as like_count 
FROM member m
CROSS JOIN book_category bc
WHERE (SELECT COUNT(*) 
				FROM book_likes bl
				JOIN book b ON bl.book_id=b.id
				WHERE bl.member_id = m.id AND b.book_category_id = bc.id) > 0;
```

---

# 💜 실전 SQL - 어떤 Query를 작성해야 할까?

<aside>
🔑 ***책이 받은 좋아요 개수를 보여준다.***

</aside>

만약 책 테이블에 좋아요 개수가 포함되어있다면 아래와 같은 query로 충분함

```sql
select likes from book;
```

그러나 likes 칼럼 없이 집계를 한다면 아래와 같은 query가 필요함

```sql
select count(*) from book_likes where book_id = {대상 책 아이디};
```

이번에는 아래 요구 사항을 추가

<aside>
🔑 ***책의 좋아요 갯수를 계산하는데, 내가 차단한 사용자의 좋아요는 집계를 하지 않는다.***

</aside>

#### 차단 테이블

책의 아이디가 3, 내 아이디가 2라고 가정

```sql
select count(*)
from book_likes
where book_id = 3 and user_id not in
(select target_id from block where owner_id = 2); 
```

위의 쿼리문을 `left join`을 사용하도록 변경 가능

### Join

---

A에도 있고 B에도 있는 것만 반환

### Left Join

---

A는 전부 반환, B에 없으면 NULL로 채움

```sql
select count(*) // 최종 행 개수 세기
from book_likes as bl // book_likes 기준 시작
left join block as b on bl.user_id = b.target_id and b.owner_id = 2
// block 테이블을 left join, bl.user_id = b.target_id -> 좋아요 누른 유저가 차단 대상인지 확인
// b.owner_id -> 차단한 사람이 나(ID=2)인 경우에만
where bl.book_id = 3 and b.target_id is null;
// 책 id가 3번이고, LEFT JOIN 이후 NULL인 것만 (나를 차단하지 않은 유저만)
```

<aside>
💡

left join 써야 하는 이유 : book_likes는 전부 살리고, block에 없는 경우에는 NULL 반환

</aside>

```sql
## LEFT JOIN을 쓰면?
```
↓ LEFT JOIN 결과
-- book_likes는 전부 살리고, block에 없으면 NULL

user_id | book_id | target_id
1       | 3       | 1       ← 차단된 유저
2       | 3       | NULL    ← block에 없으니 NULL
3       | 3       | NULL    ← block에 없으니 NULL

↓ IS NULL 필터로 차단 유저 제거

user_id | book_id | target_id
2       | 3       | NULL
3       | 3       | NULL

COUNT(*) = 2 ✅
```

---

## 실제로 접할 수 있는 요구사항

### 해시태그를 통한 책의 검색

N : M 관계로 인해 가운데 매핑 테이블이 추가 된 경우는 쉬운 쿼리로 데이터를 가져오기 힘듦

### **UMC라는 이름을 가진 해시태그가 붙은 책을 찾아보자**

### 서브쿼리 방법

```sql
select * from book where id in
	(select book_id from book_hash_tag
		where hash_tag_id = (select id from hash_tag where name = 'UMC' ));
```

### 조인 방법

```sql
select b.*
from book as b
join book_hash_tag as bht on b.id = bht.book_id
join hash_tag as ht on bht.hash_tag_id = ht.id
where ht.name = 'UMC'
```

### 책둘의 목록을 최신 순으로 조회하는 쿼리를 만들어보자

```sql
select * from book order by created_at desc;
```

최신 순 조회

### 좋아요 개수 순으로 목록 조회를 하는 쿼리를 만들어보자

```sql
select * from books as b
join
(select count(*) as like_count from book_likes group by book_id)
	as likes on b.id = likes.book_id
order by likes.like_count desc;
```

---

# 💟 실전 SQL - SQL과 페이지네이션

## 페이징 Paging

책이 100만원 있다고 할 때, 한 번에 100만개를 다 가져오면 안 됨..

Database 자체에서 데이터를 끊어서 가져오는 것을 Paging이라고 함

## Offset Based 페이징

우리가 자주 보는 페이징

직접 페이지 번호를 찾아내어 이동하는 방법

<aside>
💡

paging 쿼리는 sql마다 상이

</aside>

```sql
select *
from book
order by likes desc
limit 10 offset 0;
```

→ limit을 통해 한 페이지에서 보여줄 데이터의 개수를 정함

→ offset으로 몇 개를 건너뛸지 정함

페이지 x번에 대하여 한 페이지에 y개를 보여준다면

```sql
select *
from book
order by created_at desc
limit y offset(x - 1) * y;
```

이렇게 쿼리를 만들 수 있음 (1페이지가 첫 페이지이기 때문에 x-1로 설정)

```sql
select * from book
order by created_at desc
limit 15 offset (n - 1) * 15;
```

당연히 (n - 1) * 15로 적으면 안되고 숫자 계산해서 넣어야 함

```sql
select * from book as b
join (select count(*) as like_count
	from book_likes
	group by book_id) as likes on b.id = likes.book_id
order by likes.like_count dsec
limit 15 offset (n - 1) * 15;
```

## Offset Paging의 단점

offset paging은 직접 여러 개의 데이터를 넘어가서 가져온다는 느낌

→ 페이지가 뒤로 갈수록 넘어가는 데이터가 많아져 성능 상의 이슈가 있음

<aside>
💡

결정적인 문제

사용자가 1페이지에서 2페이지로 넘어가려는 찰나에 게시글 6개가 추가되었다

→ 1페이지에서 봤던게 또 보이네?

</aside>

---

## Cursor based 페이징

cursor paging의 경우 이름에서 유추할 수 있듯이 커서로 무언가를 가르켜 페이징을 하는 방법

커서 → 마지막으로 조회한 콘텐츠

❓ 마지막으로 조회한 책의 좋아요가 20이라면

```sql
select * from book where book.likes < 20 order by likes desc limit 15;
```

이런 형태로 가져오기 (내림차순이니까)

‼️ 실제로는 마지막으로 조회한 책의 아이디를 가져오는 서브쿼리를 작성

```sql
select * from book where books.likes < (select likes from book where id = 4) order by desc limit 15
```

### 책 목록 조회 커리를 커서 페이징으로 변경해보자

```sql
select * from book where created_at < 
	(select created_at from book where id = 3)
		order by created_at desc limit 15;
```

### 인기순 커서 페이징

```sql
select * from book as b
	 join (select count(*) as like_count 
					from book_likes 
					group by book_id) as likes
		on b.id = likes.book_id
		where likes.like_count < (select count(*) from book_likes where book_id = 3)
		order by likes.like_count desc limit 15;
```

⚠️ 잘 동작하지 않음

좋아요가 0개인 게시글이 400개이고, 마지막으로 조회한 책의 좋아요가 0이라면?

그 뒤의 책이 목록 조회가 가능할까? NO!

<aside>
💡

인기 순 정렬 같이 같은 값이 있을 수 있는 경우 정렬 기준이 하나 더 있어야 함

</aside>

```sql
select * from book as b
	 join (select count(*) as like_count 
						from book_likes
							group by book_id) as likes on b.id = likes.book_id
			where likes.like_count < (select count(*) from book_likes where book_id = 3)
				order by likes.like_count desc, b.id desc limit 15;
```

좋아요 수가 같을 경우 PK값을 기준으로 정렬 추가

→ 정렬 기준이 추가 된 것일 뿐, 좋아요 개수가 같은 book이 15개가 넘어가면 그 이상은 무시가 됨

### 좋아요 수 + 책 ID를 합쳐서 커서로 사용하는 고급 커서 페이징

```sql
LPAD(값, 총자리수, 채울문자)
CONCAT(A, B)
```

```sql
CONCAT(LPAD(likes.like_count, 10, '0'), LPAD(b.id, 10, '0'))
```

LPAD로 자리수를 맞춰주기 때문에 문자열 비교가 숫자 비교처럼 이루어짐

```sql
SELECT b.*,
       CONCAT(LPAD(likes.like_count, 10, '0'), LPAD(b.id, 10, '0')) AS cursor_value
FROM book AS b
JOIN (SELECT book_id, COUNT(*) AS like_count
      FROM book_likes
      GROUP BY book_id) AS likes ON b.id = likes.book_id
HAVING cursor_value < (SELECT CONCAT(LPAD(like_count_sub.like_count, 10, '0'), LPAD(like_count_sub.book_id, 10, '0'))
                FROM (SELECT book_id, COUNT(*) AS like_count
                      FROM book_likes
                      GROUP BY book_id) AS like_count_sub
                WHERE like_count_sub.book_id = 3) # 여기에 cursor_value 값이 들어가면 됨.
ORDER BY likes.like_count DESC, b.id DESC
LIMIT 15;
```

→ HAVING 절 안 쓰는 버전

```sql
SELECT b.*,
       CONCAT(LPAD(likes.like_count, 10, '0'), LPAD(b.id, 10, '0')) AS cursor_value
FROM book AS b
JOIN (SELECT book_id, COUNT(*) AS like_count
      FROM book_likes
      GROUP BY book_id) AS likes ON b.id = likes.book_id
WHERE CONCAT(LPAD(likes.like_count, 10, '0'), LPAD(b.id, 10, '0')) < 
      (SELECT CONCAT(LPAD(like_count_sub.like_count, 10, '0'), LPAD(like_count_sub.book_id, 10, '0'))
       FROM (SELECT book_id, COUNT(*) AS like_count
             FROM book_likes
             GROUP BY book_id) AS like_count_sub
       WHERE like_count_sub.book_id = 3) # 여기에 cursor_value 값이 들어가면 됨.
ORDER BY likes.like_count DESC, b.id DESC
LIMIT 15;

```

<aside>
💡

`WHERE` → 행(row) 하나하나에 조건

`HAVING` → 그룹으로 묶인 결과에 조건

`WHERE`은 `GROUP BY` 전에, `HAVING`은 `GROUP BY` 후에 실행됨 → `WHERE` 전에는 집계함수를 쓸 수 없음

</aside>

HAVING 버전
① 전체 데이터 JOIN
② 전부 cursor_value 계산
③ HAVING으로 필터  ← 다 계산하고 나서 버림

WHERE 버전
① 전체 데이터 JOIN
② WHERE로 먼저 필터  ← 일찍 버림
③ 남은 것만 cursor_value 계산