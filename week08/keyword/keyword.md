# OpenAPI

 : REST API를 문서화하는 표준 작성 규칙. ⇒ API를 이렇게 표현하자는 약속

# Swagger

 :  OpenAPI 규격을 기반으로 만든 도구 (시각화·문서화·테스트) 모음 ⇒  API 문서 자동화 도구 (Postman + API 명세서가 합쳐진 것이 자동으로 생성)

# TSOA(TypeScript-first OpenAPI) 
    → TypeScript 코드를 기반으로 Swagger 문서를 자동 생성해주는 라이브러리 (Code-First 방식)
    TypeScript + 데코레이터 = Swagger
장점 : 코드 & 문서 일치, 타입을 기반으로 자동 생성 → 오타, 실수 방지

# Type-Driven-Documentation    
    타입과 문서를 싱크를 맞춰 함께 관리 : 명령어 실행 → 타입 읽기 → swagger 문서 자동 생성
    장점 : 문서 따로 관리 할 필요X, 코드 & 문서 항상 일치 보장

# SOP
← 보안정책 in 워크북
: 웹 브라우저(크롬, 사파리 등)는 기본적으로 ‘출처(Origin)’가 다른 곳으로는 리소스(데이터) 요청을 보내지 못하도록 막는 것 

if SOP ❌ → CSRF(Cross-Site Request Forgery) 공격이 가능

# CORS

: 서로 다른 주소끼리 통신을 허용하는 개념

(ex. 프론트 `localhost:5500` & 백엔드 `localhost:3000` ⇒ 막힘)

← 서버에서 app.use(cors()) 설정

자주 발생하는 CORS 오류

**Case 1.** `No 'Access-Control-Allow-Origin'` → CORS 설정 자체가 안 된 경우 [프론트 주소를 명시]
**Case 2.** `x-auth-token is not allowed` → 프론트엔드가 커스텀 헤더를 보냈는데, 서버에서 허용 안 한 경우 [허용할 헤더를 추가]
**Case 3.** 쿠키 포함 요청인데 `origin: *` 로 되어있을 때 → 정확한 주소 + credentials 설정 필요

Postman으로 테스트 : CORS 오류 X  VS  프론트엔드로 테스트 :  CORS 오류

→ 브라우저가 응답 받고 막음 - 사용자 보호
→ Postman - 단순 개발자의 확인 용도여서 검사 절차 자체가 없음