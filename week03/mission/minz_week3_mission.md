
# 📌 3주차 미션 - API 명세서

## 📊 API 명세 표 (Markdown)

```markdown
| 번호 | API 이름 | Method | API Path | Request Body | Request Header | Query String |
|------|--------|--------|----------|-------------|----------------|--------------|
| 1 | 홈 화면 | GET | /api/v1/home | ❌ | Authorization: Bearer {accessToken} | ?location=안암동 |
| 1-1 | 내 포인트 조회 | GET | /api/v1/users/me/points | ❌ | Authorization: Bearer {accessToken} | - |
| 1-2 | 내 미션 목록 조회 | GET | /api/v1/users/me/missions | ❌ | Authorization: Bearer {accessToken} | ?status=IN_PROGRESS |
| 1-3 | 가게 조회 | GET | /api/v1/stores | ❌ | - | ?location=안암동 |
| 2 | 회원가입 | POST | /api/v1/users/signup | { name, email, password, nickname, birth, location } | - | - |
| 3 | 리뷰 작성 | POST | /api/v1/stores/{storeId}/reviews | { rating, content, imageUrls } | Authorization: Bearer {accessToken} | - |
| 4 | 미션 목록 조회 | GET | /api/v1/users/me/missions | ❌ | Authorization: Bearer {accessToken} | ?status=IN_PROGRESS / COMPLETED |
| 5-1 | 미션 성공 처리 (상태 변경) | PATCH | /api/v1/users/me/missions/{missionId} | { status: "COMPLETED" } | Authorization: Bearer {accessToken} | - |
| 5-2 | 미션 성공 처리 (액션 방식) | POST | /api/v1/users/me/missions/{missionId}/complete | ❌ | Authorization: Bearer {accessToken} | - |
```

---

# 📌 API 설명

## 1. 홈 화면

> 위치를 기반으로 **MY MISSION 목록 + 현재 나의 point 정보 조회**

하지만 여기서 중요한 포인트가 있다.

👉 **홈 화면은 “화면 이름”이지 리소스 이름이 아니다.**

👉 API는 화면 기준보다 **데이터 기준으로 설계하는 것이 더 적절하다.**

---

### ✔️ 홈 화면에서 필요한 데이터

* 내 포인트 (1-1)
* 내 미션 목록 (1-2)
* 위치 기반 추천 (1-3)

---

### ✔️ 설계 방식

#### 1️⃣ 하나의 API로 통합

```http
GET /api/v1/home?location=안암동
```

#### 2️⃣ 데이터 기준으로 분리

```http
GET /api/v1/users/me/points
GET /api/v1/users/me/missions?status=IN_PROGRESS
GET /api/v1/stores?location=안암동
```

---

## 2. 회원가입

```http
POST /api/v1/users/signup
```

👉 회원 정보를 받아 사용자 생성

---

## 3. 마이페이지 리뷰 작성

### ✔️ 설계 관점

👉 **리뷰는 “유저”가 아니라 “가게(store)”에 종속된 리소스**

즉,

```
❌ /users/review/{store-id}
✅ /stores/{storeId}/reviews
```

---

### ✔️ 최종 설계

```http
POST /api/v1/stores/{storeId}/reviews
```

---

### ✔️ 핵심 포인트

* `{storeId}` → **리소스 식별 (Path Variable)**
* 리뷰 내용 → **Request Body**
* 사용자 → **Authorization Header**

👉 path에 storeId가 있으므로
body에 `"store"` 필드는 **불필요한 중복 데이터**

---

## 4. 미션 목록 조회

> 진행 중 / 완료 상태별 미션 조회

---

### ❗ 기존 설계

```http
GET /api/v1/users/mission/{state}
```

---

### ✔️ 문제점

👉 `state`는 리소스 식별자가 아니라
👉 **조회 조건 (필터링 조건)**

---

### ✔️ 개선된 설계

```http
GET /api/v1/users/me/missions?status=IN_PROGRESS
GET /api/v1/users/me/missions?status=COMPLETED
```

---

### ✔️ 핵심 포인트

* Path Variable ❌
* Query String ✅

👉 **목록 조회 + 필터링 → Query 사용**

---

## 5. 미션 성공 처리

> 특정 미션을 “성공 상태”로 변경

---

### ✔️ 방법 1 (상태 변경)

```http
PATCH /api/v1/users/me/missions/{missionId}
```

```json
{
  "status": "COMPLETED"
}
```

---

### ✔️ 방법 2 (행위 중심)

```http
POST /api/v1/users/me/missions/{missionId}/complete
```

---

# 📌 API 설계 기준

## ✔️ Path Variable

👉 리소스 식별자 (id)

```
GET /posts/15
```

---

## ✔️ Request Body

👉 서버에 전달할 실제 데이터

* POST (생성)
* PATCH / PUT (수정)

---

## ✔️ Query String

👉 조회 조건 (필터링, 정렬)

```
GET /posts?status=ACTIVE&page=1
```

---

## ✔️ Request Header

👉 메타데이터 (인증, 데이터 형식)

```
Authorization: Bearer {accessToken}
Content-Type: application/json
```

---

## ❗ 주의

👉 **GET 요청에 body를 넣는 것은 비추천**
👉 조회 조건은 **Query String으로 전달**

---

# 📌 memberId 사용 기준

## ✔️ 1. Path Variable이 필요 없는 경우

👉 “현재 로그인한 사용자” 기준

```http
GET /api/v1/users/me
Authorization: Bearer {accessToken}
```

---

### 해당되는 경우

* 내 정보 조회
* 내 미션 조회
* 내가 리뷰 작성
* 내가 미션 성공 처리

👉 **memberId 필요 없음**

---

## ✔️ 2. Path Variable이 필요한 경우

👉 특정 사용자를 직접 지정해야 할 때

```http
GET /api/v1/users/17
GET /api/v1/users/17/reviews
```

---

## 🔥 최종 기준

| 상황       | memberId        |
| -------- | --------------- |
| 내 정보 기반  | ❌ 필요 없음         |
| 특정 유저 지정 | ✅ Path Variable |

---

# 🚀 한 줄 정리

👉 **Path = 식별 / Body = 데이터 / Query = 조건 / Header = 메타정보**

---