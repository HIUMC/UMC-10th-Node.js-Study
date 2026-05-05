# Niz_Week5_Mission2

### 요청 흐름 정리 (Controller → Service → Repository → DB)

1. **Client (Postman):**
사용자가 API 엔드포인트(예: `POST /api/v1/users/signup`)로 요청(Request)과 데이터(Body)를 보냄.
2. **Controller (안내데스크):** 요청을 가장 먼저 받아들임. `req.body`로 들어온 데이터를 **DTO**를 통해 검증하고, 시스템이 사용하기 편한 규격으로 변환한 뒤 **Service** 계층으로 넘겨줌.
3. **Service (실무자/비즈니스 로직):** 전달받은 데이터로 실제 비즈니스 규칙을 수행함. (예: 이메일 중복 체크, 비밀번호 해싱 등). DB 데이터 조회가 필요하면 **Repository**를 호출함.
4. **Repository (DB 전담반):** Service의 요청을 받아 실제 MySQL DB에 연결하고, 순수 SQL 쿼리문(`SELECT`, `INSERT` 등)을 실행함.
5. **DB (데이터베이스):** 쿼리를 수행하고 그 결과(성공 여부, 삽입된 데이터 ID 등)를 다시 Repository로 반환함.
6. **응답 (Response):** 결과가 `Repository → Service → Controller`의 역순으로 전달되며, Controller가 최종적으로 HTTP 상태 코드(200 OK 등)와 JSON 응답을 Client에게 반환함.