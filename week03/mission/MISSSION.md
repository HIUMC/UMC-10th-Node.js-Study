# ‼️ 참고 ERD : https://www.erdcloud.com/d/xMY5uC36dnoAWpezS

# 마이페이지

## 회원가입 POST `/api/v1/users/signup`

### **Request Header**

```xml
Content-Type : application/json
```

### Request Body

```json
{
	"email": "test@example.com",
	"password": "test1234",
	"phoneNum": "010-0000-0000",
	"name": "test",
	"gender": "F"
}
```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "회원가입이 완료되었습니다.",
  "data": {
    "id": 1,
    "name": "test"
  }
}
```

### 에러 핸들

```json
{
  "success": false,
  "code": "E400",
  "message": "필수 필드가 누락되었습니다."
}
```

```json
{
  "success": false,
  "code": "E409",
  "message": "이미 존재하는 이메일입니다."
}
```

```json
{
  "success": false,
  "code": "E400",
  "message": "이메일 또는 비밀번호의 형식이 맞지 않습니다."
}
```

## 로그인 POST `/api/v1/users/login`

### **Request Header**

```xml
Content-Type : application/json
```

### Request Body

```json
{
	"email": "test@example.com",
	"password": "test1234",
}
```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "로그인이 완료되었습니다.",
  "data": {
    "id": 1,
    "name": "test"
  }
}
```

### 에러 핸들

```json
{
  "success": false,
  "code": "E400",
  "message": "필수 필드가 누락되었습니다."
}
```

```json
{
  "success": false,
  "code": "E400",
  "message": "아이디 또는 비밀번호가 잘못되었습니다."
}
```

## 계정 탈퇴 PATCH `/api/v1/users`

### **Request Header**

```xml
Authorization : accessToken (String)
Content-Type : application/json
```

### Request Body

```json

```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "탈퇴 요청이 완료되었습니다.",
  "data": {
    "status":"deleted",
    "inactivate_date":"2026-04-02T12:00:00"
  }
}
```

### 에러 핸들

```json
{
  "success": false,
  "code": "E409",
  "message": "이미 탈퇴된 계정입니다."
}
```

## 마이페이지 **GET** `/api/v1/users/me`

### **Request Header**

```xml
Authorization : accessToken (String)
Content-Type : application/json
```

### Request Body

```json

```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "내 정보 조회에 성공했습니다.",
  "data": {
    "userId": 1,
    "email": "test@example.com",
    "name": "test",
    "point": 1500,
    "status": "active"
  }
}
```

## 내 정보 변경 PATCH `/api/v1/users/me`

### **Request Header**

```xml
Authorization : accessToken (String)
Content-Type : application/json
```

### Request Body

```json
{
	"email": "test@example.com",
	"password": "test1234",
	"phoneNum": "010-0000-0000", // phone number의 형식 정도 미리 규정
}
```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "회원정보 수정이 완료되었습니다.",
  "data": {
    "id": 1,
    "name": "test"
  }
}
```

### 에러 핸들

```json
{
  "success": false,
  "code": "E409",
  "message": "이미 존재하는 이메일입니다."
}
```

## 선호조사 조회 GET `/api/v1/users/me/preferences/categories`

### **Request Header**

```xml
Authorization : accessToken (String)
Content-Type : application/json
```

### Request Body

```json

```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "선호도 카테고리 조회 성공",
  "data": {
    "categories": [
      { "categoryId": 1, "name": "한식" },
      { "categoryId": 2, "name": "카페" },
      { "categoryId": 3, "name": "양식" },
      { "categoryId": 4, "name": "일식" },
    ]
  }
}
```

## 선호 조사 저장 PUT `/api/v1/users/me/preferences`

### **Request Header**

```xml
Authorization : accessToken (String)
Content-Type : application/json
```

### Request Body

```json
{
  "categoryIds": [1, 3]
}
```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "선호도 카테고리 저장 성공",
  "data": {
	  "id": 1,
	  "categoryIds": [1, 3]
  }
}
```

---

# 미션

## 미션 전체조회 GET `/api/v1/missions/my`

### Query string

`/api/v1/missions/my?status=진행중` 

`/api/v1/missions/my?status=진행완료`

공용으로 사용 가능

### **Request Header**

```xml
Authorization : Bearer {accessToken}
Content-Type : application/json
```

### Request Body

```json

```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "미션 조회를 완료했습니다.",
  "data": {
    "missions":[
    {
	    "missionId": 1,
	    "restaurantId": 30,
	    "restaurantName": "스타벅스 이대점",
	    "restaurantCategory": "카페",
	    "point": 500,
	    "dueDate": "2026-04-13",
	    "status": "진행중"
    },
    {
	    "missionId": 3,
	    "restaurantId": 5,
	    "restaurantName": "진돈부리",
	    "restaurantCategory": "일식",
	    "point": 500,
	    "dueDate": "2026-04-13",
	    "status": "진행완료"
    }
    ]
  }
}
```

## 미션 상세조회 GET `/api/v1/missions/{missionId}`

### **Request Header**

```xml
Authorization : Bearer {accessToken}
Content-Type : application/json
```

### Request Body

```json

```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "미션 조회를 완료했습니다.",
  "data": {
    "missionId": 1,
    "restaurantId": 30,
    "restaurantName": "스타벅스 이대점",
    "restaurantCategory": "카페",
    "point": 500,
    "dueDate": "2026-04-13",
    "status": "진행중"
  }
}
```

### 에러 핸들

```json
{
  "success": false,
  "code": "E404",
  "message": "존재하지 않는 미션입니다."
}
```

```json
{
  "success": false,
  "code": "E403",
  "message": "권한이 없는 미션입니다."
}
```

## 리뷰 작성 POST `/api/v1/missions/{missionId}/reviews`

### **Request Header**

```xml
Authorization : Bearer {accessToken}
Content-Type : application/json
```

### Request Body

```json
{
	"rating": 4.5,
	"content": "음식이 맛있어요",
	"imageList": ["url1", "url2"]
}
```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "리뷰 작성이 완료되었습니다.",
  "data": {
    "id": 1,
    "restaurantId": 30
  }
}
```

### 에러 핸들

```json
{
  "success": false,
  "code": "E404",
  "message": "존재하지 않는 미션입니다."
}
```

```json
{
  "success": false,
  "code": "E400",
  "message": "완료되지 않은 미션입니다."
}
```

```json
{
  "success": false,
  "code": "E409",
  "message": "이미 리뷰를 작성했습니다."
}
```

```json
{
  "success": false,
  "code": "E400",
  "message": "별점의 범위가 유효하지 않습니다."
}
```

## 미션 수락 PATCH `/api/v1/missions/{missionId}/start`

### **Request Header**

```xml
Authorization : Bearer {accessToken}
Content-Type : application/json
```

### Request Body

```json
{
	"status": "진행중"
}
```

→ body 안보내고 알아서 서버에서 바꿔도 됨 (이 방법이 더 적절하다고 함)

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "미션이 수락되었습니다.",
  "data": {
    "missionId": 1
  }
}
```

### 에러 핸들

```json
{
  "success": false,
  "code": "E404",
  "message": "존재하지 않는 미션입니다."
}
```

```json
{
  "success": false,
  "code": "E409",
  "message": "이미 수락된 미션입니다."
}
```

```json
{
  "success": false,
  "code": "E400",
  "message": "이미 완료된 미션입니다."
}
```

## 미션 성공 PATCH `/api/v1/missions/{missionId}/success`

### **Request Header**

```xml
Authorization : Bearer {accessToken}
Content-Type : application/json
```

### Request Body

```json
{
	"status": "진행완료"
}
```

→ body 안보내고 알아서 서버에서 바꿔도 됨 (이 방법이 더 적절하다고 함)

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "미션이 완료되었습니다.",
  "data": {
    "missionId": 1
  }
}
```

### 에러 핸들

```json
{
  "success": false,
  "code": "E404",
  "message": "존재하지 않는 미션입니다."
}
```

```json
{
  "success": false,
  "code": "E400",
  "message": "수락되지 않은 미션입니다."
}
```

```json
{
  "success": false,
  "code": "E409",
  "message": "이미 완료된 미션입니다."
}
```

---

# 지도

## 가게 전체조회 GET `/api/v1/restaurants`

### **Request Header**

```xml
Authorization : Bearer {accessToken}
Content-Type : application/json
```

### Request Body

```json

```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "가게 조회를 완료했습니다.",
  "data": {
    "restaurants":[
    {
	    "id": 30,
	    "name": "스타벅스 이대점",
	    "category": "카페",
	    "address": "서울특별시 서대문구 이화여대길 34",
	    "image": "url"
    },
    {
	    "id": 5,
	    "name": "진돈부리",
	    "category": "일식",
	    "address": "서울특별시 서대문구 신촌로 149 자이엘라 B104",
	    "image": "url"
    }
    ]
  }
}
```

## 가게 상세조회 GET `/api/v1/restaurants/{restaurantId}`

### **Request Header**

```xml
Authorization : Bearer {accessToken}
Content-Type : application/json
```

### Request Body

```json

```

### Response

```json
{
  "success": true,
  "code": "S200",
  "message": "미션 조회를 완료했습니다.",
  "data": {
    "id": 30,
    "name": "스타벅스 이대점",
    "category": "카페",
    "address": "서울특별시 서대문구 이화여대길 34",
    "image": "url"
  }
}
```

### 에러 핸들

```json
{
  "success": false,
  "code": "E404",
  "message": "존재하지 않는 가게입니다."
}
```