## 💡 워크북 링크 : https://sexypoo.notion.site/Chapter-4-Node-js-ES6-339ea94212af80e99f8ccb1d8b2d693d?source=copy_link

## ES (ECMA Script)

자바스크립트의 표준 규격을 나타내는 용어, JavaScript를 표준화시키기 위해 등장

## ES6: ES의 버전

ES5 → ES6에서 굉장히 많은 기능들이 추가됨 (주요 업데이트)

---

## ES6의 주요 변화 및 특징

### `let`, `const` 키워드 추가

이전의 `var` 키워드는 함수 레벨 스코프를 가졌고, 암묵적인 재할당이 가능했음 → 단점을 보완하기 위해 블록 레벨 스코프를 가진 `let`, `const` 추가

const : 재할당 x 상수 선언

let : 재할당 가능 변수

var : 사용 지양

### **Arrow function 추가**

화살표 함수를 통해 함수를 간결하게 나타낼 수 있음! (기존의 함수와 this 바인딩이 다르므로 주의)

- 기준의 함수는 함수 내에서 this를 찾았고, 화살표 함수는 함수 밖의 this를 유지

일반 함수 표현식

```jsx
const add = function (a, b) {
	return a+b;
};
```

화살표 함수 표현식

```jsx
const add = (a,b) => a+b;
```

### Default Parameter 추가

함수의 매개변수에 초깃값을 작성하기 위해 함수 내부에서 로직이 필요했었으나 ES6 이후 defalut parameter 추가

```jsx
// ES5

var bmi = function(height, weight){
    var height = height || 184;
    var weight = weight || 84;
    return weight / (height * height / 10000);
}

// 함수호출시 매개변수로 키와 몸무게를 할당하면, bmi를 리턴해주는 함수작성
// 파라미터가 없을시 작성자의 bmi를 리턴

// ES6

const bmi = function(height = 184, weight = 84){
	return weight / (height * height / 10000);
}
```

### Template literal 추가

```jsx
// ES5
var firstName = 'park'
var lastName = 'goeun'
var name = 'My name is ' + firstName + ' ' + lastName + '.'

// ES6
const myName = `My name is ${firstName} ${lastName}.`
console.log(myName)
```

### 모듈 기능

모듈은 모듈 스코프를 가진다.

`export`, `import` 키워드를 통해 사용

---

## ES6를 중요시 하는 이유
ES5 이하 버전에서 문제가 되었던 부분들이 해결되고 많은 기능들이 추가 → 가독성과 유지보수 측면에서 큰 향상을 가져옴

---

## ES Module

지난 주차 Express 코드에서 아래 코드 실행시 ES 모듈과 관련된 오류가 발생함

```jsx
// const express = require('express')  // -> CommonJS
import express from 'express'          // -> ES Module

const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
```

Node.js는 기본적으로 실행시 CommonJS 방식으로 실행되는데 ES Module 방식으로 실행하기 위해 별도의 설정이 필요했음

```jsx
{
  "name": "playground-umc-7th-nodejs",
  "type": "module"
}
```

<aside>
💡

ES 모듈이 도입되기 전 JS 프로그램들은 대체로 작은 편이었음

처음에는 브라우저 환경에서 약간의 스크립트 기능으로 활용됐으나, 점차 확대되며 파일들을 분리하고 필요할 때 가져올 수 있도록 개선할 필요가 생김

**이에 따라 ES6와 함께 소개된 것이 ES Module**

ES Module은 require 대신 import, export를 이용하여 라이브러리와 모듈을 더 안전하고 효율적으로 가져오게 함

import, export는 코드 실행 전에 분석됨 → 컴파일러, 번들러, Linter 등이 의존성 그래프를 정확히 하악할 수 있음 → **어떤 모듈이 어떤 모듈을 참조하는지 컴퓨터가 미리 분석할 수 있게 함!**

CommonJS와 비교하여

- 모듈 내에서 내보내기를 처리하는 방법이 더 명확하고 유연해짐
- 모듈 로드시에도 동기가 아닌 비동기 처리
</aside>

---

## TypeScript

## TypeScript?

자바스크립트의 슈퍼 셋 (상위 집합) 오픈 소스 프로그래밍 언어

슈퍼 셋 : 기존 언어의 모든 문법을 포함하며 새로운 기능을 추가한 언어

TypeScript를 이용하면 타입 검사를 통해 오류를 미리 확인할 수 있고, 런타임 오류를 줄이고 개발을 더 안정적으로 할 수 있음

## TS의 필요성

```jsx
const a = 1;
const b = '1';
console.log(a - b);
```

**⚠️ JS에서 해당 코드를 실행하면 number 타입 `0`이 출력됨**

자바스크립트는 동적 타입을 사용하는 프로그래밍 언어 → 문자열 `‘1’`이 압묵적 타입 변환으로 인해 number 타입 `1`로 변환이 되고, `1 - 1 = 0` 이 결과로 출력

코드 작성이 간결해지고 타입 간 연산을 유연하게 처리할 수 있다는 장점이 있지만 예상치 못한 동작을 발생시킬 가능성이 높아지고, 나중에는 기술 부채로 돌아올 수 있음

**‼️ TS에서 같은 코드를 실행시 아래와 같은 경고가 발생함**

```tsx
The right-hand side of an arithmetic operation must be of type 'any', 'number', 'bigint' or an enum type.
```

오른쪽의 요소는 any, int, bigint 타입 또는 enum 타입이어야 한다는 타입 경고

→ TS는 개발 단계에서 타입 오류를 미리 발견하는 것을 도움

## TypeScript의 타입

### 기본 타입

TypeScript에서 지정 가능한 대표적인 타입은 아래와 같음

- `string`
- `number`
- `boolean`
- `null`
- `undefined`
- `unknown`
- `any`

다음과 같은 형태로 변수에 명시적 타입 지정이 가능

```tsx
a: string = "UMC 10th"; // <변수이름>: <타입> = <값>
```

### 객체 타입

객체 내부의 요소에 대한 타입 지정이 가능함

```tsx
b: {
	id: number;
	name: string;
} = {
	id: 1,
	name: : "홍길동"
};
```

### 배열

모든 타입에 `[]`를 붙이게 되면 해당 타입에 대한 배열 타입으로 지정 가능

```tsx
c: number[] = [1,2,3]; // number 배열
d: string[] = ['U','M','C']; // string 배열
e: { // 객체 배열
	id: number;
	name: string;
}[] = [
	{
		id: 1,
		name: "홍길동"
	},
	{
		id: 2,
		name: "고길동"
	}
];
```

### 유니언 타입

어떤 변수에 string 값이 들어올 수도, number 값이 들어올 수도 있다면 아래와 같이 정의할 수 있음

```tsx
h: string | number;
// 두 값 모두 대입에 문제가 없음
h = "UMC";
h = 1;
```

### 함수

함수의 매개변수 타입과 반환값 타입 또한 지정이 가능함

```tsx
function test1(value: number): number{
	return value;
}

const test2 = (value: number): number => {
	return value;
}
```

### 제너릭

타입을 나중에 결정할 수 있도록 미뤄두는 것

타입 상관없이 배열의 첫 번째 값을 반환하는 함수를 구현하다면?

```tsx
function getFirstString(arr: string[]): string {
	return arr[0];
}
function getFirstNumber(arr: number[]): number{
	return arr[0];
}
```

이런 형태는 기본 타입 말고도 다른 객체나 유니온 타입이 등장하면 대응이 어렵고, 비효율적임 (몇 백 줄의 코드가 필요)

```tsx
function getFirst<T>(arr: T[]): T {
	return arr[0];
}
```

제너릭을 사용하면 이렇게 단순화가 가능함

매개변수로 입력된 값의 타입을 `T`에 담아서 그대로 재사용

### 타입 별칭

유니온 타입, 객체 타입 처럼 커스텀으로 정의가 되는 타입 중에서 여러 곳에서 재사용되는 타입이 있다면 별도로 별칭을 지정 후 재사용 가능

```tsx
type Challenger = {
	id: number;
	name: string;
}
```

이런 경우라면 아래와 같이 단순화 가능

```tsx
b: Challenger = {
	id: 1,
	name: "홍길동"
};
```

### 인터페이스 interface

객체의 형태(구조)를 정의하는 문법

```tsx
interface Challenger{
  id: number;
  name: string;
}

const me: Challenger = {
  id: 1,
  name: "홍길동",
};
```

<aside>
❓

타입과 인터페이스의 차이

둘 다 모두 타입을 정의하는 데에 사용되고, 객체의 구조를 표현할 때 비슷하게 사용됨

인터페이스는 주로 **객체의 구조를 정의**하는데 사용되고,
**타입은 객체 뿐 아니라 문자열, 유니온 등 다양한 형태의 타입 정의가 가능**함

</aside>

---

## 프로젝트 아키텍처

중요한 이유:
1. 유지보수: 코드가 역할별로 나뉘어 있으면 버그 찾을 때 어디를 봐야 하는지 바로 알 수 있음
2. 협업: 팀원이 서로 다른 부분을 동시에 작업해도 문제가 안 생김
3. 확장성: 기능 추가 시 기존 코드를 최소한으로 건드리고 새 코드만 추가할 수 있음
4. 테스트: 레이어가 분리되어 있으면 각 부분을 독립적으로 테스트할 수 있음 → DB 없이 비즈니스 로직만 테스트 하는 것도 가능

### 모듈형 모노리스 아키텍처란?

비즈니스 도메인(관심사)에 따라 모듈을 분리하는 것을 목적으로 함

모듈 단위로 분리가 되지만, 하나 하나의 서버단위에서 동작하므로 모노리스라는 단어가 붙음

**👍 비즈니스 도메인에 따라 모듈을 분리하며 얻을 수 있는 이점**

- 코드 탐색이 쉬워짐
    - 모듈이 도메인 기준으로 나뉘어 기능별 코드 위치 예측이 쉬움
    - 결제 기능에 관한 API 코드를 찾기 위해서는 `./modules/payment`로, 로그인&인증 관련 코드는 `./modules/auth`에서 우선적으로 찾을 수 있음
    - 레이어 중심이 아니라 기능 중심으로 코드 탐색 가능
- 팀 개발 충돌 가능성 감소
    - 모듈화를 하지 않고 단순 레이어드 아키텍처만 사용할 때, 서비스/레포지토리/DTO와 같은 레이어 별 디렉토리에 여러 도메인의 코드가 함께 모이기 쉬움
    → 코드가 어떤 도메인에 속하는지 경계가 흐려지고, 여러 개발자가 같은 파일이나 비슷한 위치를 동시에 수정하게 될 가능성이 커짐
    BUT! 도메인 벌 모듈 구조를 사용하게 되면 각자 담당하는 영역이 분명해지므로 협업 시 충돌 가능성 줄어듦
- 변경 영향 범위의 감소
    - 예를 들어 API를 구현할 때 결제 모듈이 상품 정보나 결제 이력과 같은 다른 도메인의 기능을 참조해야 할 수 있을 것
    - 만약 모듈의 경계가 존재하지 않는다면 한 기능을 수정할 때 어떤 부분 까지 영향이 가는지 파악이 어려움
    - 반면 모듈 단위로 책임을 분할하고, 모듈 간 접근이 정해진 인터페이스나 공개 API를 통해서만 이루어지도록 제한한다면 변경 영향 범위를 보다 더 명확하게 통제 가능

모듈 내부적으로는 레이어드 아키텍처 중 Service-Oriented Architecture 사용

<aside>
❓

레이어를 왜 나누는 걸까?

→ 비즈니스 로직을 나누기 위함! 특정 계층만 수정하고 확장이 가능해 새로운 기능을 개발하며 확장하거나 유지 보수를 할 때 이점을 가짐

</aside>

- Controller (컨트롤러)
    - 클라이언트의 요청을 받아 서비스에 전달
    - 서비스에서 처리된 데이터를 받아 클라이언트에 응답
    - 그 외에도 서비스에 전달하지 않고 단순 응답 처리를 진행 (routing)
- Service (서비스 레이어)
    - 비즈니스 로직의 캡슐화 및 추상화
    - Controller로 부터 전달된 요청을 처리하는 계층
- Data Access Layer / Repository Layer (데이터 접근 레이어 / 레포지토리 레이어)
    - DB와 직접적으로 소통하며 쿼리를 수행
    - Service 레이어에서 DB 접근이 필요할 때 이 레이어를 매개로 하여 데이터를 읽고 씀

<aside>
🌊

**워크 플로우**

클라이언트로부터 API 요청 → Controller가 요청을 받음 → 서비스 레이어로 전달 → DB가 필요하다면 Repository 레이어를 통해 DB와 상호작용 → 서비스 레이어는 비즈니스 로직 처리 → 다시 Controller로 결과값 반한 → Controller는 클라이언트에게 응답값 반환

</aside>

---

## MVC 패턴

https://m.blog.naver.com/jhc9639/220967034588

## MVC 패턴

디자인 패턴 중 하나

Model, View, Controller의 약자

하나의 어플리케이션, 프로젝트를 구성할 때 구성요소를 세 가지의 역할로 구분

<aside>
❓

간단하게 생각하면

Model: DB 접근 로직만 담당, 데이터 CRUD만 관리

View: 화면 표시만 담당, 데이터 직접 접근과 가공 X

Controller: 모델과 뷰를 연결하는 역할만, DB 직접 접근 X

</aside>

### Model 모델

데이터 처리, DB 접근 담당

**‼️ 규칙**

1. **사용자가 편집하길 원하는 모든 데이터를 가지고 있어야 함**
    
    화면 안의 네모박스에 글자가 표현된다면, 네모박스의 화면 위치 정보, 네모박스의 크기정보, 글자내용, 글자위치, 글자 포맷 정보 등을 전부 가지고 있어야 함
    
2. **뷰나 컨트롤러에 대해선 어떤 정보도 알지 말아야 함**
    
    데이터 변경이 일어났을 때 모델에서 화면 UI를 직접 조정해서 수저할 수 있도록 뷰를 참조하는 내부 속성값을 가지면 안 됨
    
3. **변경이 일어나면 변경 통지에 대한 처리방법을 구현해야 함**
    
    모델 속성 중 텍스트 정보가 변경된다면 이벤트를 발생시켜 누군가에게 전달해야 하며, 누군가 모델을 변경하는 이벤트를 보냈을 때 이를 수신할 수 있는 처리 방법을 구현해야 함. 또한 재사용 가능해야 하며 다른 인터페이스에서도 변하지 않아야 함
    

### 뷰 View

input 텍스트, 체크박스 등과 같은 사용자 인터페이스 요소

데이터 객체의 입력, 그리고 보여주는 출력을 담당

사용자가 볼 수 있는 화면

**‼️ 규칙**

1. **모델이 가지고 있는 정보를 따로 저장해서는 안됨**
    
    화면에 글자를 표시하기 위해 모델이 가지고 있는 정보를 전달받을텐데, 그 정보를 유지하기 위해서 임의의 뷰 내부에 저장하면 안됨
    
2. **모델이나 컨트롤러에 대해선 어떤 정보도 몰라야 함**
    
    다른 요소는 참조하거나 어떻게 동작하는지 알아서는 안됨. 데이터를 받으면 화면에 표시해주는 역할만 가짐
    
3. **변경이 일어나면 변경 통지에 대한 처리방법을 구현해야 함**
    
    모델과 동일하게 변경이 일어났을 때 누군게에게 변경을 알려줄 방법을 구현해야 함. 뷰에서 사용자가 화면에 표시된 내용을 변경하게 되면 이를 모델에게 전달해 모델을 변경해야 함 → 이 작업을 위해 변경 통지 기능을 구현해야 함
    

### 컨트롤러 Controller

모델과 뷰를 연결해주는 역할

주로 비즈니스 로직이 컨트롤러에서 구현됨

‼️ 규칙

1. 모델이나 뷰에 대해서 알고있어야 함
    
    모델이나 뷰는 서로의 존재를 모르고, 변경을 외부로 알리고, 수신하는 방법만 가지고 있지만 이를 컨트롤러가 중재하기 위해 모델과 그에 관련된 뷰에 대해 알아야 함
    
2. 모델이나 뷰의 변경을 모니터링 해야함
    
    모델이나 뷰의 변경을 통지 받으면, 이를 해석해 각각의 구성요소에게 통지를 해야함

---

## DTO

## DTO (Data Transfer Object)

데이터를 옮기는 객체

앞서 말한 레이어(계층)들 사이간에 데이터를 전송할 때, 클라이언트로부터 받은 데이터를 객체로 변환할 때 사용

### DTO의 필요성

DTO가 왜 필요하지? 그냥 Record 같은 객체에 데이터를 담아 전송해도 되지 않나?

코드의 통일성을 위해 DTO를 사용하는게 좋을 수 있지만 클라이언트로부터 받은 값이 한두개밖에 안되고 응답값도 비슷하다면 DTO를 사용하지 않는게 더 나을 수도 있음

유효성 검사도 값이 얼마 없는 경우 별도의 유효성 검사 코드를 작성해서 해결할 수 있음

<aside>
⚠️

하지만 여러 개의 데이터를 받아온다고 할 때 이 과정에서 데이터가 한 개 이상 누락될 수 있고, 원하는 형태로 전달되지 않을 수 있음

유효성 검사도 별도로 진행하면 코드가 복잡해짐

</aside>

```jsx
...
export class AddWishListRequestDto {
  @IsNotEmpty()
  @IsString()
  productName!: string;
  @IsNotEmpty()
  @IsNumber()
  price!: number;
  @IsUrl()
  @IsString()
  url!: string;
  @IsNotEmpty()
  @IsString()
  storeName!: string;
  @IsNotEmpty()
  @IsString()
  brandName!: string;
  @IsString()
  reason!: string;
  @IsString()
  userId!: string;
  photoFile?: Express.Multer.File;
  constructor(data: {
    userId: string;
    productName: string;
    price: number;
    url: string;
    storeName: string;
    brandName: string;
    reason: string;
    photoFile?: Express.Multer.File;
  }) {
    this.userId = data.userId;
    this.productName = data.productName;
    this.price = data.price;
    this.url = data.url;
    this.storeName = data.storeName;
    this.brandName = data.brandName;
    this.reason = data.reason;
    this.photoFile = data.photoFile;
  }
}
...
```

위 코드는 Tsoa와 Class Validator를 이용한 프로젝트의 예시 DTO

파라미터 별로 타입을 제한하고 값이 올바르게 들어왔는지 또한 Class Validator의 데코레이터 (`@IsString(), @IsNotEmpty()` 등)를 통해 검증 가능

## DTO의 사용처

1. Service → Controller
    - DTO로 데이터를 필터링하여 Controller로 전달 → Controller에서 데이터를 다룰 때 민감한 정보를 숨길 수 있음
    - ex) Service 레이어에서 가지고 있는 데이터에 패스워드가 존재하여 Controller로 넘길 때는 이를 넘기지 않으려고 할 때
2. Controller → Service
    - DTO를 통해 Service 레이어로 데이터를 전달하게 되면 서비스 함수의 범용성이 늘어나 유지보수가 용이해짐
    - ex) 회원가입 시 req.body 안에 이름, 이메일, 비밀번호가 들어옴 → 이 때 Controller에서 DTO로 변환하게 된다면 빠진 값이 있는지, 이메일 형식은 맞는지 등을 바로 검증 가능

또한 DTO를 사용하면 동일한 DB 테이블을 필요로 하는 여러 컨트롤러에서 함수를 재사용 가능