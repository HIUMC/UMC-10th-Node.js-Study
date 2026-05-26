# Niz_Week8_Keyword

## 1. Swagger vs OpenAPI

- **OpenAPI**
    - RESTful API를 설명하기 위한 공식 표준 규격(Specification).
    - JSON이나 YAML 형식으로 API의 경로, 파라미터, 응답 구조를 어떻게 표현할지 정해놓은 규약.
- **Swagger**
    - OpenAPI 표준을 기반으로 개발자들의 편리한 작업을 돕는 오픈소스 도구 모음(Tooling).

---

## 2. 타입 구동 문서화 (Type-Driven-Documentation)

→ "타입(Type)이 곧 문서(Documentation)가 된다"

- 과거의 문제점 (전통적인 방식)
    - **문서 우선(Design-First):** YAML 파일로 API를 설계하고 코드를 짜다 보니, 코드 변경 시 YAML을 매번 직접 수정해야 해서 문서가 낙오됨.
    - **코드 주석 방식:** 코드 위에 `/ @swagger ... */` 같은 거대한 JSDoc 주석을 달아 문서화. 주석이 코드보다 길어지고, 타입 시스템과 연동되지 않아 주석에 오타가 나도 잡아낼 수 없었음.
- 타입 구동 방식의 핵심 이점
    - 오직 **TypeScript의 `interface`나 `type` 선언** 하나만 관리함.
    - API 응답 타입을 수정하면, 문서도 자동으로 수정될 뿐만 아니라 프론트엔드로 전달될 타입 스펙까지 연쇄적으로 동기화됨. → 오타나 누락 원천 차단.

---

## 3. TSOA (TypeScript-first OpenAPI)

- **'타입 구동 문서화'를 Node.js 환경에서 완벽하게 구현해 주는 프레임워크**
- 개발자는 Swagger나 OpenAPI의 복잡한 문법을 알 필요가 없음.

```tsx
@Route("users")
export class UserController extends Controller {
  
  @Get("{userId}")
  public async getUser(@Path() userId: number): Promise<UserResponse> {
    return { id: userId, name: "테스터", email: "test@test.com" };
  }
}

interface UserResponse {
  id: number;
  name: string;
  email: string;
}
```

1. **데코레이터 기반 정의:** `@Route`, `@Get`, `@Path`, `@Body` 같은 직관적인 데코레이터 사용.
2. **자동 검증 빌드 (tsoa spec-and-routes):** 빌드 명령어를 실행하면, TSOA 컴파일러가 소스코드를 분석하여 두 가지를 자동으로 만들어 냄.
    - `swagger.json`: API의 모든 스펙이 담긴 OpenAPI 표준 문서
    - `routes.ts`: 라우팅 및 런타임 유효성 검사(Validation)가 포함된 실제 Express 라우터 코드
3. **런타임 유효성 검사 자동화:** 만약 클라이언트가 `userId`에 숫자가 아닌 문자열(`"abc"`)을 보내면, 개발자가 별도의 검증 코드를 짜지 않아도 TSOA가 타입을 기반으로 400 Bad Request 에러를 알아서 반환함.