# Niz_Week5_Summary

### 🛠 회원가입 API

**1. DTO (Data Transfer Object) - `user.dto.ts`**

- **역할:** 클라이언트와 서버 간에 데이터를 주고받을 때, 데이터의 형태(타입)를 강제하고 검증하는 역할
- **분석:** `UserSignUpRequest`라는 인터페이스를 생성하여 클라이언트가 보내야 하는 필수/선택 데이터의 규격을 명시함. 또한, `bodyToUser` 함수를 통해 클라이언트의 날것(Raw) 데이터(`req.body`)를 시스템에서 사용하기 편한 형태로 변환(예: 문자열 날짜를 Date 객체로 파싱)해주는 데이터 가공 역할을 수행함.

**2. Controller (컨트롤러) - `user.controller.ts`**

- **역할:** 클라이언트의 요청(Request)을 가장 먼저 받아들이고, 최종 응답(Response)을 돌려주는 안내 역할
- **분석:** `handleUserSignUp` 함수에서 클라이언트의 요청 데이터를 받아 DTO로 변환한 뒤, Service 계층으로 넘겨줌. 이후 Service 로직이 성공적으로 끝나면 HTTP 상태 코드와 함께 JSON 형태로 최종 응답을 클라이언트(Postman)에 반환함. 비즈니스 로직은 처리하지 않고 오직 **요청과 응답의 흐름만 제어함.**

**3. Service (서비스) - `user.service.ts`**

- **역할:** 실제 '비즈니스 로직(핵심 기능)'이 수행되는 곳
- **분석:** `userSignUp` 함수 내에서 시스템의 핵심 규칙들이 실행됨.
  1. 사용자 등록 전 중복된 이메일이 있는지 확인. (존재하면 Error 발생)
  2. 새 사용자를 DB에 등록(INSERT).
  3. 클라이언트가 보낸 선호 음식 카테고리(`preferences` 배열)를 반복문(for-of)으로 돌면서 사용자와 음식을 매핑(`user_favor_category`).
  - Controller와 달리 HTTP 관련 객체(`req`, `res`)를 전혀 모르며, 오직 데이터 처리에만 집중.

**4. Repository (레포지토리) - `user.repository.ts`**

- **역할:** 데이터베이스(MySQL)와 직접 소통하며 데이터를 조회, 저장, 수정, 삭제(CRUD)하는 창구
- **분석:** `mysql2/promise` 라이브러리의 Connection Pool을 이용하여 DB와 연결(`pool.getConnection()`)을 맺음. `addUser`, `setPreference` 등의 함수 내부에서 순수 SQL 쿼리문(`SELECT`, `INSERT`)을 실행하고 그 결과를 Service 계층으로 반환함. 실행이 끝나면 반드시 `conn.release()`를 통해 DB 연결 자원을 반납하여 과부하를 방지함.
