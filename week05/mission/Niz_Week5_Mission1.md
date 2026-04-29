# Niz_Week5_Mission1

#### API 1-1: 특정 지역에 가게 추가하기

- **API Endpoint:** `POST /api/v1/regions/{regionId}/stores`
- **Request Body**
  ```json
  {
    "name": "니즈네 맛집",
    "address": "서울시 안암동 123-45",
    "category_id": 1 // (예: 1번 카테고리가 '한식'인 경우)
  }
  ```
- **Response:** 성공 시 새로 추가된 가게의 ID나 정보 반환

![Niz_Week5_Mission1(1).png](<Niz_Week5_Mission1(1).png>)

---

#### API 1-2: 가게에 리뷰 추가하기

- **API Endpoint:** `POST /api/v1/stores/{storeId}/reviews`
- **Request Body**
  ```json
  {
    "userId": 1,
    "score": 5.0,
    "body": "너무 맛있어요! 단골 될 것 같습니다."
  }
  ```

![Niz_Week5_Mission1(2a).png](<Niz_Week5_Mission1(2a).png>)

![Niz_Week5_Mission1(2b).png](<Niz_Week5_Mission1(2b).png>)

---

#### API 1-3: 가게에 미션 추가하기

- **API Endpoint:** `POST /api/v1/stores/{storeId}/missions`
- **Request Body**
  ```json
  {
    "reward": 500,
    "deadline": "2026-05-30",
    "missionSpec": "10000원 이상 주문 시 500포인트 적립"
  }
  ```

![Niz_Week5_Mission1(3a).png](<Niz_Week5_Mission1(3a).png>)

![Niz_Week5_Mission1(3b).png](<Niz_Week5_Mission1(3b).png>)

---

#### API 1-4: 가게의 미션을 도전 중인 미션에 추가하기

- **API Endpoint:** `POST /api/v1/users/missions/{missionId}`
- **Request Body**
  ```json
  {
    "userId": 1
  }
  ```

![Niz_Week5_Mission1(4a).png](<Niz_Week5_Mission1(4a).png>)

![Niz_Week5_Mission1(4b).png](<Niz_Week5_Mission1(4b).png>)

---
