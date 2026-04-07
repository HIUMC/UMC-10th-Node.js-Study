# Niz_Week3_Mission

[API 명세서](API%20%EB%AA%85%EC%84%B8%EC%84%9C%20334b57f4596b80bc84d0da806cb42f81.csv)

#### 단계 1: 회원 가입 하기 (소셜 로그인 고려X)

→ 와이어프레임을 보면 약관 동의 후 '이름, 성별, 생년월일, 주소'를 입력받고,
     다음 페이지에서 '선호하는 음식 종류'를 선택하도록 되어 있음

- **API Endpoint:** `POST /api/v1/users/signup`
- **Path variable:** 없음 (아직 생성되지않은 유저이므로 식별자 ID가 없음)
- **Query String:** 없음
- **Request Header:** `Content-type: application/json`
- **Request Body**

```json
{
  "name": "김연희",
  "gender": "F",
  "birthDate": "2004-06-12",
  "address": "서울시 강남구 도곡동",
  "foodPreferences": [1, 3, 5] 
}
```

---

#### 단계 2: 홈 화면

→ 와이어프레임을 보면 '안암동'이라는 특정 지역이 선택되어 있고, 그 아래에 도전 가능한 미션들이
     페이징(스크롤)되어 나타남. 이때, 내가 이미 수락한 미션은 보이지 않아야 함.

- **API Endpoint:** `GET /api/v1/missions`
- **Path variable:** 없음 (단 하나의 특정 미션을 지목하는 것이 아니라 여러 개의 목록을 가져옴)
- **Query String:** `?regionId=1&cursor=15`
- **Request Header:** `Authorization: Bearer {accessToken}`
- **Request Body:** 없음 (GET 요청은 데이터 조회가 목적임)

---

#### 단계 3: 미션 목록 조회 (진행중, 진행 완료)

→ 와이어프레임을 보면 '진행중'과 '진행완료'라는 두 개의 탭이 있음.
     사용자가 어떤 탭을 누르느냐에 따라 각각 다른 상태의 미션 리스트가 스크롤(페이징)되어 보여야 함.

- **API Endpoint:** `GET /api/v1/users/{userId}/missions`
- **Path variable:** `{userId}` (’특정’ 유저가 가진 미션 기록을 조회하기 위해 사용)
- **Query String:** `?status=IN_PROGRESS&cursor=15` (또는 `status=COMPLETE`)
- **Request Header:** `Authorization: Bearer {accessToken}`
- **Request Body:** 없음 (GET 요청은 데이터 조회가 목적임)

---

#### 단계 4: 미션 성공 누르기

→ 와이어프레임을 보면 진행 중이던 미션에서 '성공 요청'을 하거나 사장님 번호 인증 등을 거쳐 최종적으로 
     "미션 성공! 500 포인트가 적립되었습니다."라는 팝업이 뜨는 과정을 거침. 즉, 기존에 만들어져 있던 
      `member_mission` 테이블의 특정 데이터 상태(status)를 '진행중'에서 '진행완료(또는 성공)'로 수정함.

- **API Endpoint:** `PATCH /api/v1/users/missions/{missionId}`
- **Path variable:** `{missionId}` (유저가 진행 중인 여러 미션 중 ‘특정’ 미션을 성공 처리하기 위해 사용)
- **Query String:** 없음
- **Request Header:** `Authorization: Bearer {accessToken}`
                                 `Content-Type: application/json`
- **Request Body**

```json
{
  "status": "COMPLETE"
}
```

---

#### 단계 5: 마이 페이지 리뷰 작성

→ 와이어프레임을 보면 사용자가 별점(score)과 텍스트 형태의 리뷰 내용(body)을 입력하여
     '등록하기' 버튼을 누름. ERD의 `review` 테이블을 보면 이 리뷰가 '어느 식당(`store_id`)'에 대한 것인지, 
     그리고 '누가(`member_id`)' 작성했는지 알아야 함.

- **API Endpoint:** `POST /api/v1/stores/{storeId}/reviews`
- **Path variable:** `{storeId}` (유저가 ‘특정’ 식당에 리뷰를 남기게 하기 위해 사용)
- **Query String:** 없음
- **Request Header:** `Authorization: Bearer {accessToken}`
                                 `Content-Type: application/json`
- **Request Body**

```json
{
  "score": 5.0,
  "body": "음 너무 맛있어요 포인트도 얻고 맛있는 맛집도 알게 된 것 같아 너무나도 행복한 식사였답니다. 다음에 또 올게요!!"
}
```