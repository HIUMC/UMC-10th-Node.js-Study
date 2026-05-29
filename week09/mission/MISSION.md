# 깃허브 링크: https://github.com/sexypoo/UMC-Study/issues/6
# 워크북 노션 링크: https://sexypoo.notion.site/Chapter-9-368ea94212af80bab943d04e479d92ad?source=copy_link

# 미션 🔥

## user update API 작성

### isLoggin을 미들웨어로 등록하자

`auth.middleware.ts`

```tsx

import passport from "passport";

export const isLogin = passport.authenticate('jwt', { session : false });

```

### `user.repository.ts`

```tsx

// 사용자 정보 수정

export const updateUser = async(userId: number, data:any) => {
  return await prisma.user.update({
    where:{id: userId},
    data:{
      phoneNumber: data.phoneNumber,
      birth:data.birth,
      address: data.address,
      detailAddress: data.detailAddress,
      gender:data.gender
    }
  });
};
```

### `user.service.ts`

```tsx

export const updateUserService = async (userId: number, data: Partial<{
  phoneNumber: string;
  birth: string;
  address: string;
  detailAddress: string;
  gender: string;
}>) => {
  const updated = await updateUser(userId, {
    ...data,
    birth: data.birth ? new Date(data.birth) : undefined,
  });

  return {userId: updated.id};
};
```

### `user.controller.ts`

```tsx
   /**
     * 유저 정보 수정 API
     * @summary 로그인한 유저 본인의 정보를 수정하는 엔드포인트입니다.
     */
    @Patch("me")
    @Middlewares(isLogin)
    @Response<ApiResponse<UpdateUserResponse>>(200, "유저 정보 수정 성공")
    public async handleUpdateUser(
        @Request() req: ExpressRequest,
        @Body() body: UpdateUserRequest
    ): Promise<ApiResponse<UpdateUserResponse>> {
        const userId = (req.user as any).id;
        const result = await updateUserService(userId, body);
        return success(result);
    }

}
```

미들웨어로 isLogin을 등록해주면 됨

또한, `ExpressRequest`로 미들웨어에서 `userId` 정보를 받아와 사용해야 함

<img width="1504" height="1656" alt="Image" src="https://github.com/user-attachments/assets/1db2582e-e641-4c7f-b70a-1e8ec0da0bdb" />

google 로그인으로 발급받은 토큰을 넣고 patch 요청을 넣어주면 됨

## userId가 들어간 API들 수정

지금까지 userId가 필요한 정보를 POST하거나 GET 할 때는 파라미터에 userId를 담거나 body에 담아서 보냈는데, 이도 위와 같은 방법으로 모두 수정

```tsx
    /**
     * @summary 미션 시작을 요청하는 엔드포인트입니다.
     * @param body 
     * @returns { MissionStartResponse } 미션 시작 결과
     */
    @Post("me/missions")
    @Middlewares(isLogin)
    @Response<ApiResponse<MissionStartResponse>>(200, "미션 시작 성공")
    @Response<FailResponse>(409, "이미 진행 중이거나 완료한 미션 — AlreadyChallengingMissionError (M002)", {
        resultType: "FAIL",
        error: {
            errorCode: "M002",
            reason: "이미 해당 미션을 진행 중이거나 완료했습니다.",
            data: null,
        },
        data: null,
    })
    
    public async handleStartMission(
        @Request() req: ExpressRequest,
        @Body() body: MissionStartRequest
    ): Promise<ApiResponse<MissionStartResponse>>{
        console.log("미션 시작을 요청했습니다.");
        console.log("body:", body);
        const userId = (req.user as any).id;
        const mission = await missionStart({...body, userId});
        return success(mission);
    }
}
```

기존에는 `{userId}/missions` 였던 미션 시작 요청 API를 me/missions로 수정

```tsx
/**
     * 유저 리뷰 목록 조회 API
     * @summary 특정 유저가 작성한 리뷰 목록을 반환하는 엔드포인트입니다.
     * @param cusor
     */
    @Get("me/reviews")
    @Middlewares(isLogin)
    @Response<ApiResponse<ReviewListResponse>>(200, "리뷰 목록 조회 성공")
    public async handleListUserReview(
        @Request() req: ExpressRequest,
        @Query() cursor: number = 0
    ): Promise<ApiResponse<ReviewListResponse>>{
        const userId = (req.user as any).id;
        const reviews = await listUserReviews(userId, cursor);
        return success(reviews);
    }
```

마찬가지로 `{userId}/reviews`로 조회되던 미션 조회 API를 `me/reviews`로 수정 (mission도 마찬가지로 수정)

```tsx
@Route("restaurants")
@Tags("Review")
export class ReviewController extends Controller{ 

    /**
     * @summary 리뷰 등록을 처리하는 엔드포인트입니다.
     * @param restaurantId 
     * @param body 
     * @returns { ReviewAddResponse } 리뷰 등록 결과
     */
    @Post("{restaurantId}/reviews")
    @Middlewares(isLogin)
    @Response<ApiResponse<ReviewAddRequest>>(200, '리뷰 등록 성공')
    public async handleAddReview(
        @Request() req: ExpressRequest,
        @Path() restaurantId: number,
        @Body() body: ReviewAddRequest
    ): Promise<ApiResponse<ReviewAddResponse>>{
        console.log("리뷰 등록을 요청했습니다.");
        console.log("body:", body);
        const userId = (req.user as any).id
        const review = await reviewAdd({ ...body, restaurantId, userId });
        return success(review);
    }
}
```

리뷰 등록 또한 `userId`가 필요하여 `body`를 통해 받던 것을 `ExpressRequest`로 받아서 controller 안에서 처리해서 넘김

기타 등등 유사한 API들을 컨트롤러 내에서 미들웨어 추가 후 `request`로 `userId`를 받아서 처리