미들웨어

: 요청(Request)과 응답(Response) 사이에서 동작하는 독립적인 함수

 app.use(fn)으로 등록, next()를 호출해야 다음 미들웨어로 흐름

HTTP 상태 코드

: 서버가 클라이언트에게 요청 처리 결과를 알리는 3자리 숫자 코드

ex. 2xx 성공, 3xx 리다이렉트, 4xx 클라이언트 오류, 5xx 서버 오류

에러 핸들링 (Error Handling)

Express에서 에러는 4개 인자 (err, req, res, next)를 가진 미들웨어로 전역 처리 / 서비스 레이어에서 throw로 던진 에러를 한 곳에서 일괄 처리

TSOA (TypeScript Open API)

: 데코레이터 기반으로 Express 라우팅과 Swagger 문서를 자동 생성해주는 라이브러리

- 프레임워크 vs 라이브러리
    - 프레임워크 : 전체 흐름을 주도, 개발자가 그 안에서 코드 작성 (ex. Express, Nest.js, React)
    - 라이브러리 : 개발자가 필요할 때 직접 호출해서 사용 (ex. Axios, bcrypt, morgan)