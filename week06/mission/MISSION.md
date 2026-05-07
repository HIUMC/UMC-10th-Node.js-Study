### 깃허브 주소
https://github.com/sexypoo/UMC-Study/tree/feature/chapter-06

### 노션 페이지 주소
https://sexypoo.notion.site/Chapter-6-ORM-353ea94212af809aa9e7dfe6e43f1db7?source=copy_link

## 미션

## 0. 기존에 구현했던 API  Repository 함수들을 모두 Prisma ORM을 이용하도록 변경

### `review.repository.ts`

```tsx
import { prisma } from "../../../db.config.js";

// 1. User 데이터 삽입
export const addUser = async (data: any) => {
  const user = await prisma.user.findFirst({ where: { email: data.email }});

  if (user){
    return null;
  }

  const created = await prisma.user.create({
    data: {
      email: data.email,
      name: data.name,
      password: data.password,
      gender: data.gender,
      birth: data.birth,
      address: data.address,
      detailAddress: data.detailAddress,
      phoneNumber: data.phoneNumber,
    }
  });

  return created.id;

};

// 2. 사용자 정보 얻기
export const getUser = async (userId: number) => {
  return await prisma.user.findFirstOrThrow({
    where: {
      id: userId
    }
  });
};

// 3. 음식 선호 카테고리 매핑
export const setPreference = async (userId: number, foodCategoryId: number) => {
  
  await prisma.userFavorCategory.create({
    data:{
      userId: userId,
      foodCategoryId: foodCategoryId
    },
  });
};

// 4. 사용자 선호 카테고리 반환
export const getUserPreferencesByUserId = async (userId: number) => {
  return await prisma.userFavorCategory.findMany({
    where: {
      userId: userId
    },
    include:{
      foodCategory: true,
    },
    orderBy: {
      foodCategoryId: "asc"
    },
  });
};
```

### `restaurant.repository.ts`

```tsx
import { prisma } from "../../../db.config.js"

export const getRestaurantById = async (restaurantId: number) => {
  return await prisma.user.findFirstOrThrow({
    where: {
      id: restaurantId
    }
  });
};

export const getAllRestaurantReviews = async (restaurantId: number, cursor:number) =>{
  const reviews = await prisma.review.findMany({
    select:{
      id: true,
      content: true,
      rating: true,
      restaurantId: true,
      userId: true,
      restaurant: true,
      user: true
    },
    where:{
      restaurantId,
      id:{
        gt: cursor,
      }
    },
    orderBy:{
      id: "asc"
    },
    take: 5,
  });

  return reviews;
}
```

### `mission.repository.ts`

```tsx
import { prisma } from "../../../db.config.js"

export const addMission = async (data: any) => {
  try {
    const mission = await prisma.mission.create({
      data: {
        restaurantId: data.restaurantId,
        point: data.point,
        mealPrice: data.mealPrice,
        dueDate: data.dueDate,
      },
    });

    return mission.id;
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  }
};

export const getMission = async (missionId: number) => {
  try {
    const mission = await prisma.mission.findUnique({
      where: { id: missionId },
    });

    return mission; // 없으면 Prisma가 null 반환
  } catch (err) {
    throw new Error(`오류가 발생했어요: ${err}`);
  }
};
```

![image.png](attachment:67fc7bbd-87c7-4c02-b8c5-1a86efa87028:image.png)

---

## 1. 내가 작성한 리뷰 목록

<aside>
🔀

user controller → user service → review repository

</aside>

GET `/api/v1/users/:userId/reviews`

### api 라우트 추가

```tsx
// 내가 작성한 리뷰 보기
app.get("/api/v1/users/:userId/reviews", handleListUserReview);
```

지금은 auth를 따로 관리하지 못하니까 userId를 parameter로 받아서 처리하자

### `user.controller.ts`

```tsx

export const handleListUserReview = async(req: Request, res: Response, next: NextFunction) => {
    try{
        const userId = parseInt(req.params.userId as string, 10);

        const cursor = typeof req.query.cursor === "string"
                    ? parseInt(req.query.cursor, 10)
                    : 0;
        const reviews = await listUserReviews(userId, cursor);
        res.status(StatusCodes.OK).json(reviews);
    }
    catch(err){
        next(err);
    };
}
```

### `user.service.ts`

```tsx

export const listUserReviews = async(
    userId: number,
    cursor: number
  ): Promise<ReviewListResponse> => {
      const reviews = await getAllUserReviews(userId, cursor);
      return responseFromReviews(reviews);
}
```

response는 방금 restaurant의 review를 사용할 때 쓴 dto를 재사용한다.

### `review.repository.ts`

```tsx

export const getAllUserReviews = async (userId: number, cursor: number) => {
  const reviews = await prisma.review.findMany({
    select:{
      id: true,
      content: true,
      rating: true,
      restaurantId: true,
      userId: true,
      restaurant: true,
      user: true
    },
    where:{
      userId,
      id:{
        gt: cursor,
      }
    },
    orderBy:{
      id: "asc"
    },
    take: 5,
  });

  return reviews;
}
```

### 결과

[`http://localhost:3000/api/v1/users/1/reviews`](http://localhost:3000/api/v1/users/1/reviews) 

```tsx
{
    "data": [
        {
            "id": "1",
            "content": "맛있어요!",
            "rating": 4.5,
            "restaurantId": "3",
            "userId": 1,
            "restaurant": {
                "id": "3",
                "regionId": "1",
                "name": "스시 오마카세",
                "address": "서울시 강남구 청담동 789",
                "score": 4.8,
                "createdAt": "2026-05-07T02:57:45.196Z",
                "updatedAt": "2026-05-07T02:57:45.196Z"
            },
            "user": {
                "id": 1,
                "email": "goeun2@test.com",
                "password": "$2b$10$7JN5Jv9Q6AnqubSDG/Jk3.FtZROz4BgnWxIAb2/bD6xSsAAqJ4Hou",
                "name": "박고은",
                "gender": "여성",
                "birth": "2005-04-13T00:00:00.000Z",
                "address": "서울시 서대문구 신촌동",
                "detailAddress": "207호",
                "phoneNumber": "010-1234-5678"
            }
        },
        {
            "id": "2",
            "content": "맛있어요!",
            "rating": 4.5,
            "restaurantId": "3",
            "userId": 1,
            "restaurant": {
                "id": "3",
                "regionId": "1",
                "name": "스시 오마카세",
                "address": "서울시 강남구 청담동 789",
                "score": 4.8,
                "createdAt": "2026-05-07T02:57:45.196Z",
                "updatedAt": "2026-05-07T02:57:45.196Z"
            },
            "user": {
                "id": 1,
                "email": "goeun2@test.com",
                "password": "$2b$10$7JN5Jv9Q6AnqubSDG/Jk3.FtZROz4BgnWxIAb2/bD6xSsAAqJ4Hou",
                "name": "박고은",
                "gender": "여성",
                "birth": "2005-04-13T00:00:00.000Z",
                "address": "서울시 서대문구 신촌동",
                "detailAddress": "207호",
                "phoneNumber": "010-1234-5678"
            }
        },
        {
            "id": "3",
            "content": "맛있네요",
            "rating": 4,
            "restaurantId": "3",
            "userId": 1,
            "restaurant": {
                "id": "3",
                "regionId": "1",
                "name": "스시 오마카세",
                "address": "서울시 강남구 청담동 789",
                "score": 4.8,
                "createdAt": "2026-05-07T02:57:45.196Z",
                "updatedAt": "2026-05-07T02:57:45.196Z"
            },
            "user": {
                "id": 1,
                "email": "goeun2@test.com",
                "password": "$2b$10$7JN5Jv9Q6AnqubSDG/Jk3.FtZROz4BgnWxIAb2/bD6xSsAAqJ4Hou",
                "name": "박고은",
                "gender": "여성",
                "birth": "2005-04-13T00:00:00.000Z",
                "address": "서울시 서대문구 신촌동",
                "detailAddress": "207호",
                "phoneNumber": "010-1234-5678"
            }
        },
        {
            "id": "4",
            "content": "맛있어용용용",
            "rating": 3,
            "restaurantId": "2",
            "userId": 1,
            "restaurant": {
                "id": "2",
                "regionId": "1",
                "name": "황금 치킨",
                "address": "서울시 강남구 논현동 456",
                "score": 4.2,
                "createdAt": "2026-05-07T02:57:45.196Z",
                "updatedAt": "2026-05-07T02:57:45.196Z"
            },
            "user": {
                "id": 1,
                "email": "goeun2@test.com",
                "password": "$2b$10$7JN5Jv9Q6AnqubSDG/Jk3.FtZROz4BgnWxIAb2/bD6xSsAAqJ4Hou",
                "name": "박고은",
                "gender": "여성",
                "birth": "2005-04-13T00:00:00.000Z",
                "address": "서울시 서대문구 신촌동",
                "detailAddress": "207호",
                "phoneNumber": "010-1234-5678"
            }
        },
        {
            "id": "5",
            "content": "맛있어용용용",
            "rating": 4.5,
            "restaurantId": "2",
            "userId": 1,
            "restaurant": {
                "id": "2",
                "regionId": "1",
                "name": "황금 치킨",
                "address": "서울시 강남구 논현동 456",
                "score": 4.2,
                "createdAt": "2026-05-07T02:57:45.196Z",
                "updatedAt": "2026-05-07T02:57:45.196Z"
            },
            "user": {
                "id": 1,
                "email": "goeun2@test.com",
                "password": "$2b$10$7JN5Jv9Q6AnqubSDG/Jk3.FtZROz4BgnWxIAb2/bD6xSsAAqJ4Hou",
                "name": "박고은",
                "gender": "여성",
                "birth": "2005-04-13T00:00:00.000Z",
                "address": "서울시 서대문구 신촌동",
                "detailAddress": "207호",
                "phoneNumber": "010-1234-5678"
            }
        }
    ],
    "pagination": {
        "cursor": "5"
    }
}
```

![image.png](attachment:53f5ec2d-ae4b-4482-9c58-0b3af2707dd4:image.png)

---

## 2. 특정 가게의 미션 목록

<aside>
🔀

restaurant controller → restaurant service → mission repository

</aside>

GET `/api/v1/restaurant/:restaurantId/missions`

### api 라우트 추가

```tsx
// 특정 가게의 미션 목록
app.get("/api/v1/restaurant/:restaurantId/missions", handleListRestaurantMissions);
```

### `restaurant.controller.ts`

```tsx
export const handleListRestaurantMissions = async(
    req: Request,
    res: Response,
    next: NextFunction
): Promise<void> => {
    try{
        const resId = parseInt(req.params.restaurantId as string, 10);

        const cursor = typeof req.query.cursor === "string"
            ? parseInt(req.query.cursor, 10)
            : 0;
        const missions = await listRestaurantMissions(resId, cursor);
        res.status(StatusCodes.OK).json(missions);
    } catch(err){
        next(err);
    }
};
```

### `restaurant.service.ts`

```tsx
export const listRestaurantMissions = async(
    restaurantId: number,
    cursor: number
): Promise<MissionListResponse> => {
    const missions = await getAllRestaurantMissions(restaurantId, cursor);
    return responseFromMissions(missions);
}
```

`MissionListResponse`와 `responseFromMissions`가 구현되어있지 않기 때문에 `mission.dto.ts`에 작성해주자

```tsx

export interface MissionItem {
  id: number;
  restaurantId: number;
  point: number;
  mealPrice: number;
  dueDate: string;
  createdAt: string;
  updatedAt: string;

  restaurant:{
    name: string;
  }
}

export interface MissionListResponse {
  data: MissionItem[];
  pagination: {
    cursor: number | null;
  };
}

export const responseFromMissions = (missions: MissionItem[]): MissionListResponse => {
  const lastMission = missions[missions.length - 1];
  return {
    data: missions,
    pagination: {
      cursor: lastMission ? lastMission.id : null,
    },
  };
};
```

### `mission.repository.ts`

```tsx
export const getAllRestaurantMissions = async (restaurantId: number, cursor: number) => {
  const missions = await prisma.mission.findMany({
    select:{
      id: true,
      restaurantId: true,
      point: true,
      mealPrice: true,
      dueDate: true,
      restaurant: true

    },
    where:{
      restaurantId,
      id:{
        gt: cursor,
      }
    },
    orderBy:{
      id: "asc"
    },
    take: 5,
  });

  return missions;
}
```

### 결과

[`http://localhost:3000/api/v1/restaurants/2/missions`](http://localhost:3000/api/v1/restaurants/2/missions) 

```tsx
{
    "data": [
        {
            "id": "2",
            "restaurantId": "2",
            "point": 500,
            "mealPrice": 15000,
            "dueDate": "2026-12-31T00:00:00.000Z",
            "restaurant": {
                "id": "2",
                "regionId": "1",
                "name": "황금 치킨",
                "address": "서울시 강남구 논현동 456",
                "score": 4.2,
                "createdAt": "2026-05-07T02:57:45.196Z",
                "updatedAt": "2026-05-07T02:57:45.196Z"
            }
        },
        {
            "id": "4",
            "restaurantId": "2",
            "point": 500,
            "mealPrice": 15000,
            "dueDate": "2026-12-31T00:00:00.000Z",
            "restaurant": {
                "id": "2",
                "regionId": "1",
                "name": "황금 치킨",
                "address": "서울시 강남구 논현동 456",
                "score": 4.2,
                "createdAt": "2026-05-07T02:57:45.196Z",
                "updatedAt": "2026-05-07T02:57:45.196Z"
            }
        }
    ],
    "pagination": {
        "cursor": "4"
    }
}
```

![image.png](attachment:5164619e-daa7-4c7b-81db-73a0580e2b6f:image.png)

---

## 3. 내가 진행 중인 미션 목록

<aside>
🔀

user controller → user service → user-mission repository

</aside>

GET `/api/v1/users/:userId/missions`

이번에도 userId를 따로 세션으로 알아올 수 없으니 param으로 대체해서 개발하자

user가 수락한 mission은 mission 테이블이 아닌 user-mission 테이블에서 저장하고 있기 때문에 user-mission repository를 사용하자

### api 라우트 추가

```tsx

// 특정 유저의 미션 목록
app.get("/api/v1/users/:userId/missions", handleListUserMission);

```

### user.controller.ts

### 결과

[`http://localhost:3000/api/v1/users/2/missions`](http://localhost:3000/api/v1/users/2/missions)

```tsx
{
    "data": [
        {
            "id": "1",
            "userId": 2,
            "missionId": "1",
            "status": "진행중",
            "createdAt": "2026-05-07T11:42:07.587Z",
            "updatedAt": "2026-05-07T11:42:07.587Z",
            "mission": {
                "id": "1",
                "restaurantId": "3",
                "point": 500,
                "mealPrice": 15000,
                "dueDate": "2026-12-31T00:00:00.000Z",
                "createdAt": "2026-05-07T06:59:28.723Z",
                "updatedAt": "2026-05-07T06:59:28.723Z"
            }
        },
        {
            "id": "2",
            "userId": 2,
            "missionId": "2",
            "status": "진행중",
            "createdAt": "2026-05-07T11:42:10.466Z",
            "updatedAt": "2026-05-07T11:42:10.466Z",
            "mission": {
                "id": "2",
                "restaurantId": "2",
                "point": 500,
                "mealPrice": 15000,
                "dueDate": "2026-12-31T00:00:00.000Z",
                "createdAt": "2026-05-07T07:03:11.609Z",
                "updatedAt": "2026-05-07T07:03:11.609Z"
            }
        }
    ],
    "pagination": {
        "cursor": "2"
    }
}
```

![image.png](attachment:5871ccfc-e0b6-4fc7-9a28-59a157adcca5:image.png)

