# 1. 홈 화면 조회
Endpoint: GET /api/v1/users/me/home
Header: Authorization: Bearer {accessToken}

# 2. 마이 페이지 리뷰 작성
Endpoint: POST /api/v1/stores/me/reviews
Header: Authorization: Bearer {accessToken}, Content-Type: application/json
Path Variable: storeId
Body: storeId, score

# 3. 미션 목록 조회
Endpoint: GET /api/v1/users/me/missions
Header: Authorization: Bearer {accessToken}
Query String: status=ONGOING|COMPLETE, page, size

# 4. 미션 성공 누르기
Endpoint: PATCH /api/v1/users/me/missions/{missionId}/complete
Header: Authorization: Bearer {accessToken}
Path Variable: userId, missionId

# 5. 회원 가입
Endpoint: POST /api/v1/users
Header: Content-Type: application/json
Body: name, email, password, phone, gender, birthDate, address