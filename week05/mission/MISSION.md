### 깃허브 저장소 주소
https://github.com/sexypoo/UMC-Study/tree/feature%2Fchapter-05

### 워크북 주소
https://sexypoo.notion.site/Chapter-5-API-352ea94212af80e49d66f2ad52a665d8?source=copy_link

---

# 1-2 가게에 리뷰 추가

### POST `/api/v1/restaurants/{restaurantId}/reviews`

### request

```json
{
  "userId": 1,
  "rating": 4.5,
  "content": "맛있어요!"
}
```

### response

```json
{
  "result": {
    "id": 10,
    "restaurantraId": 1,
    "userId": 1,
    "rating": 4.5,
    "content": "맛있어요!",
    "createdAt": "2026-04-30T12:34:56.000Z"
  }
}

```

![image.png](attachment:586c143d-6fe4-48cb-8a20-03377ec3466e:image.png)

![image.png](attachment:755ac56a-167f-4569-8872-0b7dd5707fad:image.png)

---

## DB 테이블 생성

review는 restaurant을 참조하기 때문에 restaurant 테이블을 먼저 만들자

```sql
CREATE TABLE umc.restaurant (
           id          BIGINT          AUTO_INCREMENT PRIMARY KEY,
           region_id   BIGINT          NOT NULL,
           name        VARCHAR(100)    NOT NULL,
           address     VARCHAR(255)    NOT NULL,
           score       FLOAT           DEFAULT 0.0,
           created_at  DATETIME        DEFAULT CURRENT_TIMESTAMP,
           updated_at  DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

restaurant에 더미 데이터를 삽입하자

```sql
INSERT INTO umc.restaurant (region_id, name, address, score) VALUES
                     (1, '맛있는 한식당',    '서울시 강남구 역삼동 123',     4.5),
                     (1, '황금 치킨',        '서울시 강남구 논현동 456',     4.2),
                     (1, '스시 오마카세',    '서울시 강남구 청담동 789',     4.8),
                     (2, '부산 돼지국밥',    '서울시 마포구 합정동 321',     4.3),
                     (2, '이탈리안 키친',    '서울시 마포구 망원동 654',     4.1),
                     (2, '양꼬치 천국',      '서울시 마포구 홍대입구 987',   3.9),
                     (3, '전주 비빔밥',      '서울시 종로구 인사동 111',     4.6),
                     (3, '북경 짜장면',      '서울시 종로구 낙원동 222',     4.0),
                     (3, '삼겹살 파티',      '서울시 종로구 관철동 333',     4.4),
                     (4, '해물 칼국수',      '서울시 송파구 잠실동 444',     4.7);

```

review 테이블을 만들고, user와 restaurant 테이블을 참조한다

```sql
CREATE TABLE umc.review (
       id            BIGINT       AUTO_INCREMENT PRIMARY KEY,
       restaurant_id BIGINT       NOT NULL,
       user_id       INT       NOT NULL,
       rating        FLOAT        NOT NULL,
       content       TEXT         NOT NULL,
       created_at    DATETIME     DEFAULT CURRENT_TIMESTAMP,
       updated_at    DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

       FOREIGN KEY (restaurant_id) REFERENCES umc.restaurant(id),
       FOREIGN KEY (user_id) REFERENCES umc.user(id)
);
```

---

### 폴더 구조

![image.png](attachment:69a1df8b-807e-429d-9895-d442c1b06015:image.png)

### index.ts에 라우팅 추가

```tsx
// 1-2 가게에 리뷰 추가
app.post("/api/v1/restaurants/:restaurantId/reviews", handleAddReview);
```

### `reviews.controller.ts` handleAddReview 작성

```tsx
import { Request, Response, NextFunction } from "express";
import { StatusCodes } from "http-status-codes";
import { ReviewAddRequest, bodyToReview } from "../dtos/review.dto.js";
import { reviewAdd } from "../services/review.service.js";

export const handleAddReview = async(req: Request, res: Response, next: NextFunction) => {
    console.log("리뷰 등록을 요청했습니다.");
    console.log("body:", req.body);

    const restaurantId = Number(req.params.restaurantId);
    const { userId, rating, content } = req.body; 

    // 서비스 로직 호출
    const review = await reviewAdd(bodyToReview({
        restaurantId,
        userId,
        rating,
        content
    } as ReviewAddRequest));
    // 성공 응답 보내기
    res.status(StatusCodes.OK).json({result:review});
}
```

<aside>
🔥

파라미터를 받아와야 하기 때문에 아래와 같은 코드 작성

```tsx
const restaurantId = Number(req.params.restaurantId);
```

</aside>

### `review.dto.ts` 작성

```tsx
import e from "express";

export interface ReviewAddRequest {
    restaurantId:number,
    userId: number,
    rating: number,
    content: string
}

export const bodyToReview = (body: ReviewAddRequest) => {
  return {
    restaurantId: body.restaurantId,
    userId: body.userId,
    rating: body.rating,
    content: body.content
  }
};

export interface ReviewAddResponse {
  id: number;
  restaurantId: number;
  userId: number;
  rating: number;
  content: string;
  createdAt:string;
}

export const responseFromReview = (review: ReviewAddResponse) =>{
    return{
        id: review.id,
        restaurantId: review.restaurant_id,
        userId: review.user_id,
        rating: review.rating,
        content: review.content,
        createdAt: review.created_at
    }
}
```

### `review.service.ts` 작성

```tsx
import { ReviewAddRequest } from "../dtos/review.dto.js"; //인터페이스 가져오기 
import { responseFromReview } from "../dtos/review.dto.js";
import {
  addReview,
  getReview,
} from "../repositories/review.repository.js";

import {getRestaurantById} from "../../restaurants/repositories/restaurant.repository.js";

export const reviewAdd = async (data: ReviewAddRequest) => {

    const restaurant = await getRestaurantById(data.restaurantId);
    if (!restaurant) {
        throw new Error("존재하지 않는 가게예요.");
    }

  const reviewId = await addReview({
    restaurantId: data.restaurantId,
    userId: data.userId,
    rating: data.rating,
    content: data.content
  });

  if (reviewId == null){
    throw new Error("review 등록에 실패하였습니다.")
  }

  const review = await getReview(reviewId);

  return responseFromReview(review);
};
```

#### 리뷰를 등록하려는 가게가 존재하는지 검사하는 로직

```tsx
const restaurant = await getRestaurantById(data.restaurantId);
    if (!restaurant) {
        throw new Error("존재하지 않는 가게예요.");
    }
```

restaurant의 repository에서 `getRestaurantById`를 호출하고, 만약 Id가 리턴되지 않는다면 존재하지 않는 것!

`restaurant.repository.ts`에 `getRestaurantById`를 작성해주자

```tsx
import { ResultSetHeader, RowDataPacket } from "mysql2";
import { pool } from "../../../db.config.js";

export const getRestaurantById = async (restaurantId: number): Promise<any | null> => {
  const conn = await pool.getConnection();

  try {
    const [rows] = await pool.query<RowDataPacket[]>(
      `SELECT * FROM restaurant WHERE id = ?;`,
      [restaurantId]
    );

    return rows[0] || null;
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  } finally {
    conn.release();
  }
};
```

### `review.repository.ts` 작성

```tsx
import { ResultSetHeader, RowDataPacket } from "mysql2";
import { pool } from "../../../db.config.js";

export const addReview = async (data: any): Promise<number | null> => {
  const conn = await pool.getConnection();

    try{
    const [result] = await pool.query<ResultSetHeader>(
      `INSERT INTO review (restaurant_id, user_id, rating, content) VALUES (?, ?, ?, ?);`,
      [
        data.restaurantId,
        data.userId,
        data.rating,
        data.content
      ]
    );

    return result.insertId;
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  } finally {
    conn.release();
  }
};

export const getReview = async (reviewId: number): Promise<any | null> => {
  const conn = await pool.getConnection();

  try {
    const [review] = await pool.query<RowDataPacket[]>(
      `SELECT * FROM review WHERE id = ?;`,
      [reviewId]
    );

    if (review.length === 0) {
      return null;
    }

    return review[0];
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  } finally {
    conn.release();
  }
};

```

---

# 1-3 가게에 미션 등록

### POST `/api/v1/restaurants/{restaurantId}/missions`

### request

```json
{
  "point": 500,
  "mealPrice": 15000,
  "dueDate": "2026-12-31"
}
```

### response

```json
{
  "result": {
    "id": 1,
    "restaurantraId": 4,
    "point": 500,
    "dueDate":"2026-12-31T15:00:00:000Z",
    "createdAt": "2026-04-30T12:34:56.000Z"
  }
}

```

![image.png](attachment:082f772d-eb16-43bd-ad6a-dbc2471e5f0a:image.png)

---

## DB 테이블을 만들자

restaurant 테이블은 1-2에서 이미 만들었으므로 mission 테이블을 만들자

```sql
CREATE TABLE umc.mission (
          id            BIGINT      AUTO_INCREMENT PRIMARY KEY,
          restaurant_id BIGINT      NOT NULL,
          point         INT         NOT NULL,
          meal_price    INT         NOT NULL,
          due_date      DATE        NOT NULL,
          created_at    DATETIME    DEFAULT CURRENT_TIMESTAMP,
          updated_at    DATETIME    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

          FOREIGN KEY (restaurant_id) REFERENCES umc.restaurant(id),
);
```

---

### 폴더 구조

![image.png](attachment:0b7d5005-be23-47c2-a6da-58a3ad95d896:image.png)

### `index.ts` 라우팅 추가

```tsx
app.post("/api/v1/restaurants/:restaurantId/missions", handleAddMission);
```

### `mission.controller.ts` handleAddMission 작성

```tsx
export const handleAddMission = async(req: Request, res: Response, next: NextFunction) => {
    console.log("미션 추가를 요청했습니다.");
    console.log("body:", req.body);

    const restaurantId = Number(req.params.restaurantId);
    const { point, mealPrice, dueDate } = req.body; 

    // 서비스 로직 호출
    const mission = await missionAdd(bodyToMission({
        restaurantId,
        point,
        mealPrice,
        dueDate
    } as MissionAddRequest));
    // 성공 응답 보내기
    res.status(StatusCodes.OK).json({result:mission});
}
```

### `mission.dto.ts` 작성

```tsx
import e from "express";

export interface MissionAddRequest {
    restaurantId:number,
    point:number,
    mealPrice:number,
    dueDate:string
}

export const bodyToMission = (body: MissionAddRequest) => {
  return {
    restaurantId: body.restaurantId,
    point:body.point,
    mealPrice: body.mealPrice,
    dueDate: body.dueDate
  }
};

export interface MissionAddResponse {
  id: number;
  restaurantId:number,
  point:number,
  mealPrice:number,
  dueDate:string
  createdAt:string;
}

export const responseFromMission = (mission: MissionAddResponse) =>{
    return{
        id: mission.id,
        restaurantId: mission.restaurant_id,
        point: mission.point,
        dueDate: mission.due_date,
        createdAt: mission.created_at
    }
}
```

### `mission.service.ts` 작성

```tsx
import { MissionAddRequest } from "../dtos/mission.dto.js"; //인터페이스 가져오기 
import { responseFromMission } from "../dtos/mission.dto.js";
import {
  addMission,
  getMission,
} from "../repositories/mission.repository.js";

import {getRestaurantById} from "../../restaurants/repositories/restaurant.repository.js";

export const missionAdd = async (data: MissionAddRequest) => {

    const restaurant = await getRestaurantById(data.restaurantId);
    if (!restaurant) {
        throw new Error("존재하지 않는 가게예요.");
    }

  const missionId = await addMission({
    restaurantId: data.restaurantId,
    point: data.point,
    mealPrice: data.mealPrice,
    dueDate: data.dueDate
  });

  if (missionId == null){
    throw new Error("mission 등록에 실패하였습니다.")
  }

  const mission = await getMission(missionId);

  return responseFromMission(mission);
};

```

1-2에서 만든 restaurant 검증 로직을 재사용한다.

### `mission.repository.ts` 작성

```tsx
import { ResultSetHeader, RowDataPacket } from "mysql2";
import { pool } from "../../../db.config.js";

export const addMission = async (data: any): Promise<number | null> => {
  const conn = await pool.getConnection();

    try{
    const [result] = await pool.query<ResultSetHeader>(
      `INSERT INTO mission (restaurant_id, point, meal_price, due_date) VALUES (?, ?, ?, ?);`,
      [
        data.restaurantId,
        data.point,
        data.mealPrice,
        data.dueDate
      ]
    );

    return result.insertId;
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  } finally {
    conn.release();
  }
};

export const getMission = async (missionId: number): Promise<any | null> => {
  const conn = await pool.getConnection();

  try {
    const [mission] = await pool.query<RowDataPacket[]>(
      `SELECT * FROM mission WHERE id = ?;`,
      [missionId]
    );

    if (mission.length === 0) {
      return null;
    }

    return mission[0];
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  } finally {
    conn.release();
  }
};

```

---

# 1-4 미션 수락

### POST `/api/v1/users/{userId}/missions`

기존에는 미션이 1:1이라고 생각했음

user - mission 1:1 관계라고 생각했기 때문에 mission table 자체에 user_id를 넣는 방법을 생각했고 수락시 user_id를 채워놓고 status를 수정해야지! 라고 생각함 → `patch`

그런데 mission을 만들 때 가게와 묶어서 만들게 된다면 (1-2번) 이런 방식은 좋지 않다고 생각

하나의 mission에 도전하는 여러 user가 있을 수 있음, user-mission 테이블을 새로 만들고 `post`로 하자!

### request

```json
{
  "missionId": 1,
  "status": "진행중"
}
```

### response

```json
{
  "result": {
    "id": 1,
    "userId": 2,
    "missionId": 1,
    "status": "진행중",
    "createdAt": "2026-05-01T04:07:42.000Z"
  }
}

```

![image.png](attachment:15187e6e-2cee-49dc-9d05-f646c52e77f0:image.png)

![image.png](attachment:5ef9eabd-5fa8-42f5-a12a-35ed41a04f5d:image.png)

이미 도전 중인 미션을 골랐을 경우

---

## DB 테이블 만들기

![image.png](attachment:ff90f208-7b1a-47a7-973a-dfe426f624f8:image.png)

User와 Mission을 매핑해줄 친구인 user_mission 테이블을 새로 만들었다

---

### 파일 구조

![image.png](attachment:aded0f22-2868-4560-a6f1-35ad6599bd34:image.png)

controller, service, dto, repository도 mission과 헷갈려서 같은 모듈 안에 user-mission 파일을 새로 만들었다

### `index.ts` 라우터 추가

```tsx
app.post("/api/v1/users/:userId/missions", handleStartMission);
```

### `user-mission.controlle`r에 `handleStartmission`추가

```tsx
import { Request, Response, NextFunction } from "express";
import { StatusCodes } from "http-status-codes";

import { MissionStartRequest, bodyToUserMission } from "../dtos/user-mission.dto.js";
import { missionStart } from "../services/user-mission.service.js";

export const handleStartMission = async(req: Request, res: Response, next: NextFunction) => {
    console.log("미션 등록 요청했습니다.");
    console.log("body:", req.body);

    const userId = Number(req.params.userId);
    const { missionId, status } = req.body; 

    // 서비스 로직 호출
    const user_mission = await missionStart(bodyToUserMission({
        userId,
        missionId,
        status
    } as MissionStartRequest));
    // 성공 응답 보내기
    res.status(StatusCodes.OK).json({result:user_mission});
}

```

### `user-mission.dto.ts`

```tsx
export interface MissionStartRequest {
    userId: number,
    missionId: number,
    status: string
}

export const bodyToUserMission = (body: MissionStartRequest) => {
  return {
    userId: body.userId,
    missionId: body.missionId,
    status: body.status
  }
};

export interface MissionStartResponse {
  id: number;
  userId: number,
  missionId: number,
  status: string
  createdAt:string;
}

export const responseFromStartMission = (mission: MissionStartResponse) =>{
    return{
        id: mission.id,
        userId: mission.user_id,
        missionId: mission.mission_id,
        status: mission.status,
        createdAt: mission.created_at
    }
}
```

### `user-mission.service.ts`  작성

```tsx
import { MissionStartRequest } from "../dtos/user-mission.dto.js"; //인터페이스 가져오기 
import { responseFromStartMission } from "../dtos/user-mission.dto.js";
import {
  addUserMission,
  getUserMission,
} from "../repositories/user-mission.repository.js";

import { getUserMissionByUserIdAndMissionId } from "../repositories/user-mission.repository.js";

export const missionStart = async (data: MissionStartRequest) => {

  const isAlreadyChallenging = await getUserMissionByUserIdAndMissionId(
    data.userId,
    data.missionId
  );

  if (isAlreadyChallenging) {
    throw new Error("이미 도전 중인 미션이에요.");
  }

  const userMissionId = await addUserMission({
    userId: data.userId,
    missionId: data.missionId,
    status: data.status
  });

  if (userMissionId == null){
    throw new Error("mission 등록에 실패하였습니다.")
  }

  const userMission = await getUserMission(userMissionId);

  return responseFromStartMission(userMission);
};
```

#### 도전중 처리 로직

```tsx
const isAlreadyChallenging = await getUserMissionByUserIdAndMissionId(
    data.userId,
    data.missionId
  );

  if (isAlreadyChallenging) {
    throw new Error("이미 도전 중인 미션이에요.");
  }
```

user의 이메일 중복 로직과 동일하게 설계하면 된다.

repository에 `getUserMissionbyUserId`라는 함수를 만들어주자!

```tsx
export const getUserMissionByUserIdAndMissionId = async (
  userId: number,
  missionId: number
): Promise<any | null> => {
  const conn = await pool.getConnection();

  try {
    const [rows] = await pool.query<RowDataPacket[]>(
      `SELECT EXISTS(
        SELECT 1 FROM user_mission 
        WHERE user_id = ? AND mission_id = ? AND status = '진행중'
      ) as isAlreadyChallenging;`,
      [userId, missionId]
    );

    return rows[0]?.isAlreadyChallenging;  // 0 또는 1
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  } finally {
    conn.release();
  }
};
```

이메일 중복 처리 로직과 똑같이 만들면 된다.

### `user-mission.repository.ts`

```tsx
import { ResultSetHeader, RowDataPacket } from "mysql2";
import { pool } from "../../../db.config.js";

export const getUserMissionByUserIdAndMissionId = async (
  userId: number,
  missionId: number
): Promise<any | null> => {
  const conn = await pool.getConnection();

  try {
    const [rows] = await pool.query<RowDataPacket[]>(
      `SELECT EXISTS(
        SELECT 1 FROM user_mission 
        WHERE user_id = ? AND mission_id = ? AND status = '진행중'
      ) as isAlreadyChallenging;`,
      [userId, missionId]
    );

    return rows[0]?.isAlreadyChallenging;  // 0 또는 1
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  } finally {
    conn.release();
  }
};

export const addUserMission = async (data: any): Promise<number | null> => {
  const conn = await pool.getConnection();

    try{
    const [result] = await pool.query<ResultSetHeader>(
      `INSERT INTO user_mission (user_id, mission_id, status) VALUES (?, ?, ?);`,
      [
        data.userId,
        data.missionId,
        data.status
      ]
    );

    return result.insertId;
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  } finally {
    conn.release();
  }
};

export const getUserMission = async (userMissionId: number): Promise<any | null> => {
  const conn = await pool.getConnection();

  try {
    const [user_mission] = await pool.query<RowDataPacket[]>(
      `SELECT * FROM user_mission WHERE id = ?;`,
      [userMissionId]
    );

    if (user_mission.length === 0) {
      return null;
    }

    return user_mission[0]; // 배열의 첫 번째 요소(리뷰 정보)를 반환합니다.
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  } finally {
    conn.release();
  }
};

```

---

# Controller → Service → Repository → DB로 이어지는 요청 흐름

### 가게에 리뷰 추가 POST /api/v1/restaurants/{restaurantId}/reviews

1. 사용자가 `POST /api/v1/restaurants/1/reviews` 요청을 보냄
2. `handleAddReview` (Controller) 에서 `req.params.restaurantId`와 `req.body` 꺼냄
3. `bodyToReview()`로 body 데이터 변환
4. `reviewAdd` (Service) 호출
5. `getRestaurantById` (Repository) 에서 가게 존재 여부 확인 (`SELECT * FROM restaurant WHERE id = ?`)
6. 가게 없으면 에러 throw → `400` 응답
7. 가게 있으면 `addReview` (Repository) 에서 `INSERT INTO review` 실행 → `insertId` 반환
8. `getReview` (Repository) 에서 방금 생성된 review 조회
9. `responseFromReview()` (DTO) 로 응답 형식 변환 (snake_case → camelCase)
10. `200 OK`와 함께 변환된 review 정보 응답

---

### 3. 가게에 미션 추가 `POST /api/v1/restaurants/:restaurantId/missions`

1. 사용자가 `POST /api/v1/restaurants/1/missions` 요청을 보냄
2. `handleAddMission` (Controller) 에서 `req.params.restaurantId`와 `req.body` 꺼냄
3. `bodyToMission()`으로 body 데이터 변환
4. `missionAdd` (Service) 호출
5. `getRestaurantById` (Repository) 에서 가게 존재 여부 확인
6. 가게 없으면 에러 throw → `400` 응답
7. 가게 있으면 `addMission` (Repository) 에서 `INSERT INTO mission` 실행 → `insertId` 반환
8. `getMission` (Repository) 에서 방금 생성된 mission 조회
9. `responseFromMission()` (DTO) 로 응답 형식 변환
10. `200 OK`와 함께 변환된 mission 정보 응답

---

### 4. 미션 도전하기 `POST /api/v1/users/:userId/missions`

1. 사용자가 `POST /api/v1/users/2/missions` 요청을 보냄
2. `handleStartMission` (Controller) 에서 `req.params.userId`와 `req.body.missionId` 꺼냄
3. `missionStart` (Service) 호출
4. `getUserMissionByUserIdAndMissionId` (Repository) 에서 이미 도전 중인 미션인지 확인 (`SELECT EXISTS`)
5. 이미 도전 중이면 에러 throw → `400` 응답
6. 도전 중 아니면 `addUserMission` (Repository) 에서 `INSERT INTO user_mission` 실행 → `insertId` 반환
7. `getUserMission` (Repository) 에서 방금 생성된 user_mission 조회
8. `responseFromUserMission()` (DTO) 로 응답 형식 변환
9. `200 OK`와 함께 변환된 user_mission 정보 응답

---

# 회원가입에 비밀번호 해싱 적용

bcrypt 설치

```bash
npm install bcrypt
npm install -D @types/bcrypt
```

### `user.dto.ts`에 password 추가

request에만 추가하고 response에는 추가하면 안됨

```tsx
// 1. 회원가입 요청 데이터의 설계도를 만듭니다.
export interface UserSignUpRequest {
  email: string;
  password: string;
  name: string;
  gender: string;
  birth: string | Date;
  address?: string;       // ?가 붙으면 '없을 수도 있음(선택)'이라는 뜻이에요!
  detailAddress?: string;
  phoneNumber: string;
  preferences: number[];
}

// 2. 요청받은 데이터를 우리 시스템에 맞는 데이터로 변환해주는 함수입니다. 
export const bodyToUser = (body: UserSignUpRequest) => {
  const birth = new Date(body.birth); //날짜 변환

  return {
    email: body.email, //필수 
    password: body.password,
    name: body.name, // 필수
    gender: body.gender, // 필수
    birth, // 필수
    address: body.address || "", //선택 
    detailAddress: body.detailAddress || "", //선택 
    phoneNumber: body.phoneNumber,//필수
    preferences: body.preferences,// 필수 
  };
};

```

### `user.service.ts`  비밀번호 해싱 기능 넣기

bcrypt 모듈 불러온 후 해싱 적용, 폼에 담아 보내기

```tsx
import bcrypt from "bcrypt"

export const userSignUp = async (data: UserSignUpRequest) => {

  const hashedPassword = await bcrypt.hash(data.password,10);

  const joinUserId = await addUser({
    email: data.email,
    password: hashedPassword,
    name: data.name,
    gender: data.gender,
    birth: new Date(data.birth), // 문자열을 Date 객체로 변환해서 넘겨줍니다. 
    address: data.address,
    detailAddress: data.detailAddress,
    phoneNumber: data.phoneNumber,
  });

```

### `user.repository.ts`  password 추가

```tsx

    // 삽입 결과는 ResultSetHeader 타입을 사용합니다.
    const [result] = await pool.query<ResultSetHeader>(
      `INSERT INTO user (email, password, name, gender, birth, address, detail_address, phone_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?);`,
      [
        data.email,
        data.password,
        data.name,
        data.gender,
        data.birth,
        data.address,
        data.detailAddress,
        data.phoneNumber,
      ]
    );
```

INSERT문에 password 포함

![image.png](attachment:3cd504f6-6a5b-46d0-b64c-44583a762d44:image.png)

회원가입에 비밀번호 해싱 적용

