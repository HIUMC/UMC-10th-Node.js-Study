### github 링크
https://github.com/sexypoo/UMC-Study/issues/4

### 노션 링크
https://sexypoo.notion.site/Chapter-7-Express-API-35bea94212af8013aeb3cb1122573f49?source=copy_link

# TSOA 방식으로 router들 수정

## user module

### `user.controller.ts`

user controller의 `handleListUserReview`와 `handleListUserMission` 을 tsoa 방식으로 수정

```tsx
@Get("{userId}/reviews")
    public async handleListUserReview(
        @Request() req: ExpressRequest,
        @Path() userId: number,
        @Query() cursor: number = 0
    ): Promise<ApiResponse<ReviewListResponse>>{
        const reviews = await listUserReviews(userId, cursor);
        return success(reviews);
    }

    @Get("{userId}/missions")
    public async handleListUserMission(
        @Request() req: ExpressRequest,
        @Path() userId: number,
        @Query() cursor: number = 0
    ): Promise<ApiResponse<UserMissionListResponse>>{
        const missions = await listUserMissions(userId, cursor);
        return success(missions);
    }
```

### `index.ts`

```tsx

// 내가 작성한 리뷰 보기
app.get("/api/v1/users/:userId/reviews", handleListUserReview)

// 특정 유저의 미션 목록
app.get("/api/v1/users/:userId/missions", handleListUserMission);
```

제거

### 결과

<img width="1504" height="1656" alt="image" src="https://github.com/user-attachments/assets/baf9efa8-055d-4130-a472-216f640f6159" />

<img width="1504" height="1656" alt="image" src="https://github.com/user-attachments/assets/01adede5-fffd-45f5-901d-268974638c9a" />

---

## restaurant module

### `restaurant.controller.ts`

`handleListRestaurantReviews`와 `handleListRestaurantMissions`를 tsoa 방식으로 수정

```tsx
@Route("restaurants")
@Tags("Restaurants")
export class RestaurantController extends Controller{ 

    @Get("{resId}/reviews")
    public async handleListRestaurantReviews(
        @Path() resId: number,
        @Query() cursor: number=0
    ): Promise<ApiResponse<ReviewListResponse>>{
        const reviews = await listRestaurantReviews(resId, cursor);
        return success(reviews);
    }

    @Get("{resId}/missions")
    public async handleListRestaurantMissions(
        @Path() resId: number,
        @Query() cursor: number=0
    ): Promise<ApiResponse<MissionListResponse>>{
        const missions = await listRestaurantMissions(resId, cursor);
        return success(missions);
    }

}
```

### `index.ts`

```tsx
// 가게에 속한 모든 리뷰 조회
app.get("/api/v1/restaurants/:restaurantId/reviews", handleListRestaurantReviews);

// 특정 가게의 미션 목록
app.get("/api/v1/restaurants/:restaurantId/missions", handleListRestaurantMissions);
```

삭제

### 결과

<img width="1504" height="1656" alt="image" src="https://github.com/user-attachments/assets/9daf2f91-78fc-49c8-b435-48dea9fba188" />

<img width="1504" height="1656" alt="image" src="https://github.com/user-attachments/assets/f1176916-83bf-4311-9b4c-77e3e1804c23" />

---

## Review module

### `review.controller.ts`

`handleAddReview`를 tsoa 방식으로 수정

```tsx
@Route("restaurants")
@Tags("Review")
export class ReviewController extends Controller{ 

    @Post("{restaurantId}/reviews")
    public async handleAddReview(
        @Path() restaurantId: number,
        @Body() body: ReviewAddRequest
    ): Promise<ApiResponse<ReviewAddResponse>>{
        console.log("리뷰 등록을 요청했습니다.");
        console.log("body:", body);
        const review = await reviewAdd({ ...body, restaurantId });
        return success(review);
    }
}
```

### `review.dto.ts`

`bodyToReview` 함수 삭제

```tsx
// DTO는 인터페이스(타입 정의)만 있으면 충분
export interface ReviewAddRequest { ... }
export interface ReviewAddResponse { ... }
export interface ReviewItem { ... }
export interface ReviewListResponse { ... }
```

### `index.ts`

```tsx
// 1-2 가게에 리뷰 추가
app.post("/api/v1/restaurants/:restaurantId/reviews", handleAddReview);
```

삭제

### 결과

<img width="1504" height="1656" alt="image" src="https://github.com/user-attachments/assets/4cfe1457-5acd-4085-a08a-ddee20e29fc4" />


---

## Mission module

### `mission.controller.ts`

`handleAddMission`을 `tsoa` 방식으로 수정

```tsx
@Route("restaurants")
@Tags("Mission")
export class MissionController extends Controller{ 

    @Post("{restaurantId}/missions")
    public async handleAddMission(
        @Path() restaurantId: number,
        @Body() body: MissionAddRequest
    ): Promise<ApiResponse<MissionAddResponse>>{
        console.log("미션 추가를 요청했습니다.");
        console.log("body:", body);
        const mission = await missionAdd({...body, restaurantId});
        return success(mission);
    }
}
```

### `mission.dto.ts`

사용하지 않는 함수들 삭제

```tsx
// DTO는 인터페이스(타입 정의)만 있으면 충분
export interface MissionAddRequest { ... }
export interface MissionAddResponse { ... }
export interface MissionItem { ... }
export interface MissionListResponse { ... }
```

### `index.ts`

```tsx
// 1-3 가게에 미션 추가
app.post("/api/v1/restaurants/:restaurantId/missions", handleAddMission);
```

삭제

<img width="1504" height="1656" alt="image" src="https://github.com/user-attachments/assets/80a14b17-1e52-4e00-a35f-11b4a2aa3285" />


---

### `user-mission.controller.ts`

`handleStartMission`을 tsoa 방식으로 수정

```tsx
@Route("users")
@Tags("UserMission")
export class UserMissionController extends Controller{ 

    @Post("{userId}/missions")
    public async handleStartMission(
        @Path() userId: number,
        @Body() body: MissionStartRequest
    ): Promise<ApiResponse<MissionStartResponse>>{
        console.log("미션 시작을 요청했습니다.");
        console.log("body:", body);
        const mission = await missionStart({...body, userId});
        return success(mission);
    }
}
```

### `mission.service.ts`

```tsx
if (!restaurant) {
      throw new Error("존재하지 않는 가게예요.");
    }
```

```tsx
if (missionId == null){
    throw new Error("mission 등록에 실패하였습니다.")
  }
```

위 두 곳에서 사용할 에러 만들기

### `error.ts`

```tsx
export class RestaurantNotFoundError extends AppError {
    constructor(message: string, data?: unknown) {
        super({
            errorCode: "R001",
            statusCode: 404,
            message,
            data,
        });
    }
}

export class MissionAddError extends AppError {
    constructor(message: string, data?: unknown) {
        super({
            errorCode: "M001",
            statusCode: 500,
            message,
            data,
        });
    }
}
```

`service` 코드 아래와 같이 수정

```tsx
if (!restaurant) {
      throw new RestaurantNotFoundError("존재하지 않는 가게예요.");
    }
```

```tsx
if (missionId == null){
    throw new MissionAddError("mission 등록에 실패하였습니다.")
  }
```

### `user-mission.service.ts`

```tsx
if (isAlreadyChallenging) {
    throw new Error("이미 도전 중인 미션이에요.");
  }
```

```tsx
if (userMissionId == null){
    throw new Error("mission 등록에 실패하였습니다.")
  }
```

위 두곳에서 사용할 에러 만들기

### `error.ts`

```tsx
export class AlreadyChallengingMissionError extends AppError {
    constructor(message: string, data?: unknown) {
        super({
            errorCode: "M002",
            statusCode: 409,
            message,
            data,
        });
    }
}

export class MissionStartError extends AppError {
    constructor(message: string, data?: unknown) {
        super({
            errorCode: "M003",
            statusCode: 500,
            message,
            data,
        });
    }
}
```

`service` 코드 아래와 같이 수정

### 결과

<img width="1504" height="1656" alt="image" src="https://github.com/user-attachments/assets/f4f2c00e-95d2-4b03-90ba-f6dea6e0a61f" />
