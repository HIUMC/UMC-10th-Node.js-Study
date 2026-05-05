### 환경 변수 Environment Variable

프로세스가 컴퓨터에서 동작하는 방식에 영향을 미치는 동적인 값들의 모임

### `dotenv`

응용 프로그램에 삽입될 환경변수를 담아 놓은 설정 파일

주로 비대칭 서명키, 데이터베이스 접근 비밀번호 등 버전 관리 시스템(git)에 커밋되면 안되는 인증 정보를 설정하는 용도로 사용되지만 서비스의 여러 설정을 담는 용도로도 많이 사용

### 원리

현재 디렉토리에 `.env` 라는 파일을 만듦

파일명이 . 으로 시작하는 이유는 Unix 환경에서 숨김 파일로 처리되기 때문

```tsx
USERNAME=sephiroth
PASSWORD=1q2w3e4r
```

이렇게 환경변수=값 형태의 설정을 담게 됨

프로그램이 실행될 때 `.env` 파일을 읽어 각각의 환경변수명을 파일에 저장된 값으로 등록, 이 때 이미 존재하는 환경변수가 있다면 덮어씌우지 않고 실제 프로세스에 설정된 값을 우선함

### 장점

- 소스 비종속성
    - 프로그램의 소스코드로 간주되지 않음, 코드베이스에서 안전하게 제거 가능 → `.env`에 담긴 파일을 빌드 종속성으로 집어넣거나 빌드 중에 사용하는 것은 것은 안티 패턴
    - 버전 관리 시스템에 커밋되지 않으므로 하드코딩으로 인한 유출 방지 가능
- 로컬 재사용성
    - 파일에 환경변수를 저장하기 때문에 매 실행마다 입력하지 않아도 됨
    - `.env` 파일을 다른 개발자에게 넘겨 동일한 환경을 빠르게 구성하는 용도로 사용될 수도 있음

---

https://developer.mozilla.org/ko/docs/Web/HTTP/Guides/CORS

## CORS (Cross-Origin Resource Sharing)

CORS는 브라우저가 자신의 출처가 아닌 어떤 출처로부터 자원을 로딩하는 것을 허용하도록 서버가 허가 해주는 헤더 기반 메커니즘

### 출처 Origin

```tsx
https://foo.example:3000/api/data
│       │             │
scheme  host         port
```

scheme + host + port 3개가 완전히 같아야 같은 출처, 하나라도 다르면 다른 출처임

### 왜 CORS가 필요한가

브라우저에는 Same-Origin Policy (동일 출처 정책)이 있음

다른 출처에 JS로 HTTP 요청을 보내는 것을 막아버림

```tsx
프론트: localhost:3000 (React)
백엔드: localhost:8080 (Node.js)
→ 포트가 다르니까 Cross-Origin!
→ fetch() 하면 브라우저가 막음
```

→ 이걸 허용해주는 메커니즘이 CORS

서버가 이 출처를 믿는다고 헤더로 선언하면 브라우저가 풀어줌

### 요청 종류 2가지

#### 1. 단순 요청

GET/HEAD/POSTS + 평범한 헤더 + Content-Type이 `text/plain`, `application/x-www-form-urlencoded`, `multipart/form-data`  중 하나

바로 요청을 보내고 응답 헤더에서 허용 여부 확인

#### 2. 사전 요청

PUT/DELETE/PATCH + 커스텀 헤더(`Authorization`, `Content-Type: application/json` ) 사용시

실제 요청 전에 OPTIONS 메서드로 먼저 허락을 구함

JSON 통신은 무조건 여기 해당

---

## DB Connection

애플리케이션과 데이터베이스 서버가 통신할 수 있도록 하는 기능

### Connection 이후

Connection 객체 사용: 반환된 Connection 객체를 사용하여 DB 관련 작업 실행

연결 종료: 작업을 마치면 닫음

<aside>
🔥

DB를 연결할 때마다 Connection 객체를 새로 만드는 것은 비용이 많이 들고 비효율적

</aside>

## DB Connection Pool

Connection 객체의 반복적 생성과 해제를 피하고 효율적으로 DB를 관리할 수 있도록 사용됨

<aside>
🔥

DB Connection Pool이란 DB로의 추가 요청이 필요할 때 연결을 재사용할 수 있도록 관리되는 DB 연결의 캐시

</aside>

애플리케이션 시작 시 미리 일정 수의 Connection 객체를 생성하여 Pool에 보관하고, DB 작업이 필요할 때마다 Pool에서 Connection 객체를 가져다 사용하고 작업이 끝나면 반환

### DB Connection Pool의 장점

- 성능 향상
- 자원의 효율적 관리
- 동시성 관리: 동시의 여러 요청 처리 가능
- 연결 풀링: 연결의 개수를 제한하고 초과 요청이 들어올 경우 대기하도록 처리함으로써 부하를 관리하고 과부하 장지
- 커넥션 오버헤드 감소

### DB Connection Pool의 단점

- 리소스 사용: 일정 수의 연결을 미리 생성 및 유지해야 하므로 리소스 일정 부분 소비
- 설정 및 관리의 복잡성: 다양한 환경에서 최적의 성능을 발휘하기 위해서는 관리와 모니터링이 필요함
- 커넥션 누수: 애플리케이션에서 연결을 올바르지 않게 하거나 예외가 발생하는 경우 연결이 제대로 반환되지 않을 수 있음

---

https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Statements/async_function

## async function

`AsyncFunction` 객체를 반환하는 하나의 비동기 함수를 정의

### 비동기 함수

이벤트 루프를 통해 비동기적으로 작동하는 함수, 암묵적으로 `Promise`를 사용하여 결과를 반환

### Syntax

```tsx
async function name([param[, param[, ... param]]]) {
        statements
    }
```

### await

`async` 함수의 실행을 일시중지 하고 전달 된 `Promise`의 해결을 기다린 다음 `async` 함수의 실행을 다시 시작하고 값을 반환

`await` 키워드는 `async` 함수에서만 유효함

```tsx
async function foo() {
  await 1;
}
```

위의 코드는 아래와 동일

```tsx
function foo() {
  return Promise.resolve(1).then(() => undefined);
}
```

---

## try..catch 문

`try` 블록과 `catch` 블록, `finally` 블록 중 하나 혹은 두 블록으로 구성

`try` 블록 내 코드가 먼저 실행되고 그 안에서 예외가 발생한다면 `catch` 블록의 코드가 실행됨

`finally` 블록 내 코드는 항상 실행됨 (제어 흐름이 전체 구문을 종료하기 전에 실행)

### 문법

```tsx
try {
  tryStatements
} catch (exceptionVar) {
  catchStatements
} finally {
  finallyStatements
}
```

<aside>
🔥

try 문은 항상 try 블록으로 시작하고, catch 블록 또는 finally 블록 중 하나가 반드시 존재해야 함 (둘 다 가질 수 있음)

</aside>

세 가지 형태가 있음

- `try … catch`
- `try … finally`
- `try … catch … finally`

### catch 바인딩

`try` 블록에서 예외가 발생하면 `exceptionVar` (즉, catch (e) 에서의 e)에 예외 값이 저장됨

이 바인딩을 통해 예외에 대한 정보를 얻을 수 있고, 해당 바인딩은 `catch` 블록의 scope에서만 사용 가능

### finally 블록

`try` 블록과 `catch` 블록들이 실행된 후에 실행할 구문을 포함하지만 `try … catch … finally` 블록 다음(뒤)의 구문들보다 무조건 먼저 실행됨

제어 흐름은 항상 `finally` 블록으로 진행함

- `try` 블록이 정상적인 실행을 마치고 실행
- `catch` 블록이 정상적인 실행을 마치고 실행
- try 블록이나 `catch` 블록에서 제어 흐름 구문 (`return`, `throw`, `break`, `continue`)이 실행되어 해당 블록을 벗어나기 직전에 실행

`catch` 블록이 없어도 `finally` 블록은 실행됨

```tsx
openMyFile();
try {
  // tie up a resource
  writeMyFile(theData);
} finally {
  closeMyFile(); // always close the resource
}
```

---

## Interface

일반적으로 타입 체크를 위해 사용됨

변수, 함수, 클래스에 사용 가능

인터페이스는 여러가지 타입을 갖는 프로퍼티로 이루어진 새로운 타입 정의와 유사

인터페이스에 선언된 프로퍼티 또는 메서드의 구현을 강제하여 일관성을 유지할 수 있게 해줌

프로퍼티와 메서드를 가질 수 있다는 점에서 클래스와 유사하지만 인스턴스의 생성이 불가하고 모든 메소드는 추상 메소드 (그러나, 추상 클래스의 추상 메소드와 달리 `abstract` 키워드를 사용하지 않음)

---

https://radlohead.gitbook.io/typescript-deep-dive/type-system/type-assertion

## Type Assertion

TS에서는 시스템이 추론 및 분석한 타입 내용을 우리가 원하는대로 얼마든지 바꿀 수 있음

이 때 Type Assertion이라 불리는 매커니즘 사용

타입을 강제하는 것

```tsx
interface Foo {
    bar: number;
    bas: string;
}
var foo = {} as Foo;
foo.bar = 123;
foo.bas = 'hello';
```

## Type Assertion vs Casting

Type Assertion을 Type Casting이라고 하지 않는 이유는 Casting이란 실행 시간에 어떤 동작이 일어날 것임을 내포하기 때문

Type Assertion은 순수하게 컴파일 시간의 구성물이고, 당신의 코드가 어떤 식으로 분석되길 원하는지 컴파일러에게 힌트를 제공하는 수단

### Type Assertion은 해롭다?

Type Assertion은 조심해서 사용해야 함

컴파일러는 당신이 깜빡해서 약속한 속성을 추가하지 않은 경우에도 당신을 보호해주지 않음

```tsx
interface Foo {
    bar: number;
    bas: string;
}
var foo = {} as Foo;
// 아.. 뭐 잊은 거 없나요?
```

### 매번 해로운 것은 아님

다소 위험하지만 완전히 해롭지많은 않음

아래와 같은 코드는 사용자가 전달된 이벤트에 대해 좀 더 명확한 정보를 알고 있도록 해주므로 의도한대로 동작됨

```tsx
function handler (event: Event) {
    let mouseEvent = event as MouseEvent;
}
```

하지만 아래와 같이 오류로 assertion을 진행하면 TS에서는 에러가 날 것

```tsx
function handler(event: Event) {
    let element = event as HTMLElement; /// Error: Neither 'Event' nor type 'HTMLElement' is assignable to the other
}
```

### Double Assertion

그럼에도 타입을 사용하고 싶다면 아래와 같이 Double Assertion을 사용할 수 있음

```tsx
function handler(event: Event) {
    let element = event as any as HTMLElement; // 오케이!
}
```