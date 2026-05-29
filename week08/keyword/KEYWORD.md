## 🌳 Swagger

Open API Specification(OAS)를 위한 프레임워크

OpenAPI에서 빼놓을 수 없는 기능

## 🌲 OpenAPI

누구나 사용할 수 있도록 공개된 API

### 🍎 OAS OpenAPI Specification

RESTful 웹서비스를 약속된 규칙에 따라 약속된 규칙에 맡게 API 스펙을 json과 yaml 형식으로 표현

직접 소스코드를 보거나 추가 문서 필요없이 서비스 이해 가능

### 🍏 Swagger

API들이 가지고 있는 specification(스펙/spec/명세)를 관리할 수 있는 프로젝트

API 문서화 작업을 손으로 하게 되면 API가 수정될 때마다 문서를 수정해야하는 불편함이 생김

### 👉 Swagger의 기능

1. API 디자인: `Swagger-editor`를 통해 API를 문서화하고 빠르게 명세할 수 있음
2. API Development: `Swagger-codegen`을 통해 작성된 문서로 SDK를 생성하여 빌드 프로세스를 간소화할 수 있음
3. API Documentation: `Swagger-UI`를 통해 작성된 API를 시각화시킴
4. API Testing: `Swagger-Insepector`를 통해 API를 시각화하고 빠른 테스팅이 가능함
5. Standardize: `Swagger-hub`를 통해 개인, 팀원들이 API 정보를 공유하는 Hub

## 💙 TSOA (TypeScript Open API)

특정 방식으로 작성된 컨트롤러 코드를 정적 분석하여 OpenAPI 스펙에 맞게 `express` 등 http 라이브러리에 대응하는 코드로 빌드해주는 라이브러리

### 👉 TSOA 사용

컨트롤러 클래스를 TSOA에서 요구하는 방법대로 작성하고, 작성한 컨트롤러 파일이 프로젝트의 어느 경로에 위치하는지 등의 정보를 잘 설정만 한다면 개발자가 원하는 파일구조를 정해서 개발할 수 있음

TOSA는 컨트롤러 코드, 컨트롤러가 참조하는 타입 파일들을 읽어 그 결과를 런타임에서도 읽을 수 있는 코드로 변환

→ 이 때 타입 정의 뿐 아니라 주석까지도 파싱

<aside>
💡

TSOA를 사용하여 API 개발을 하면 인터페이스에 제대로 타입 정의를 하고 주석만 꼼꼼히 써줘도 Request에 대한 자동 Type Validation, API 문서 자동 생성이 가능함

</aside>

## 🚕 Type-Driven-Documentation

코드의 타입 시스템을 문서화의 핵심으로 활용하는 방식

주석으로 설명하는 대신 타입 자체가 코드의 의도와 제약을 설명하게 함

```jsx
// ❌ 타입 없이 주석으로 설명
// userId는 숫자여야 하고, name은 비어있으면 안 됨
function createUser(userId, name) { ... }

// ✅ 타입이 곧 문서
type UserId = number;
type NonEmptyString = string & { __brand: "NonEmpty" };

function createUser(userId: UserId, name: NonEmptyString) { ... }
```

타입을 보는 것 만으로도 어떤 값을 넣어야 하는가가 명확해짐

### 👉 구체적인 기법들

#### Branded Types

같은 원시타입이라도 의미를 구분

```jsx
type UserId = number & { __brand: "UserId" };
type ProductId = number & { __brand: "ProductId" };
// UserId를 ProductId 자리에 못 넣음 → 실수 방지
```

#### 유니온 타입으로 상태 표현

```jsx
// 가능한 상태가 타입에 다 드러남
type OrderStatus = "pending" | "shipped" | "delivered" | "cancelled";
```

#### 불가능한 상태를 타입으로 제한

```jsx
// ❌ 이런 조합이 가능해버림 (isLoggedIn=true인데 user=null?)
type BadState = { isLoggedIn: boolean; user: User | null };

// ✅ 타입이 논리적으로 불가능한 케이스를 차단
type State = { isLoggedIn: false } | { isLoggedIn: true; user: User };
```

### 👍 Type-Driven의 장점

| 일반 주석 문서 | Type-Driven |
| --- | --- |
| 코드 바뀌면 주석이 틀려짐 | 타입은 컴파일러가 검증 |
| 읽어야만 앎 | IDE가 자동으로 보여줌 |
| 강제성 없음 | 틀리면 빌드 에러 |