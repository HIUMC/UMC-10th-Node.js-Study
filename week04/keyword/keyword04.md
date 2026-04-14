## Node.js와 ES6 기반 개발 기초

  → 모듈형 모놀리스(Modular Monolith)를 지향한 레이어드 아키텍처([Service Layer Pattern](https://en.wikipedia.org/wiki/Service_layer_pattern)) 이용

앱을 '비즈니스 목적(도메인)' 단위로 완전히 벽을 쳐서 나누는 거대한 아키텍처 설계 방식

하나의 서버(Monolith) 안에서 돌아가지만, 내부적으로는 모듈들이 완전히 독립적인 부서처럼 동작 

- **Controller(컨트롤러)**
    - 클라이언트의 요청을 받아 서비스에 전달함
    - 서비스에서 처리된 데이터를 받아 클라이언트에게 응답
    - 그외 서비스에 전달하지 않고 단순 응답 처리를 진행하기도 함(routing)
- **Service Layer (서비스 레이어)**
    - 실제 데이터 가공 및 핵심 로직 수행
    - 비즈니스 로직의 캡슐화 및 추상화
    - Controller로 부터 전달된 요청을 처리하는 계층
- **Data Access Layer / Repository Layer (데이터 접근 레이어 / 레포지토리 레이어)**
    - DB와 직접적으로 소통하며 쿼리를 수행함
    - Service 레이어에서 DB 접근이 필요할때 이 레이어를 매개로 하여 데이터를 읽고 쓰게 된다

DTO (Data Transfer Object) - 데이터를 옯기는 객체

: 레이어(계층)들 사이간에 데이터를 전송할때, 그리고 클라이언트로부터 받은 데이터를 객체로 변환할때도 사용

DTO 필요성

1. 보안 및 민감 정보 숨기기
2. DB 모델(Entity) 보호 및 의존성 분리
3. 데이터 유효성 검사

DTO의 사용처

1. **Service → Controller** 
    - DTO로 데이터를 필터링하여 Controller로 전달함으로써 Controller에서 데이터를 다룰때 민감한 정보를 숨길 수 있다는 장점
        - ex) Service 레이어에서 가지고 있는 데이터에 패스워드가 존재하여 Controller로 넘길때는 이를 넘기지 않으려고 할때
2. **Controller → Service** 
    - DTO를 통해 Service레이어로 데이터를 전달하게 되면 서비스 함수의 범용성이 늘어나서 유지 보수가 용이
        - ex) 회원가입 시에 req.body 안에 이름, 이메일, 비밀번호가 들어옴. 이 때 Controller에서 DTO로 변환하게 되면 → 빠진 값이 있는지, 이메일 형식은 맞는지 등을 검증할 수 있음
- `public` : 정적 파일들을 보관하는 폴더 (예 : 이미지 파일)
- `node_modules` : Node.js 라이브러리들이 저장되어 있는 폴더 (자동생성)
- `src` : 소스 코드들을 저장하는 폴더
    - `modules/users` : 각 도메인별 모듈이 담겨있는 폴더. 그중 users 모듈
        - `controllers`: Controller 코드들을 저장하는 곳
        - `dtos` : DTO 코드를 저장하는 곳
        - `repositories` : 데이터 / DB 조작, 제어와 관련된 코드가 저장되는 곳
        - `services` :  Service 레이어 관련 코드가 저장되는 곳