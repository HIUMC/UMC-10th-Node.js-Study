https://velog.io/@dnjscksdn98/Database-ORM%EC%9D%B4%EB%9E%80

## Object-Relational Mapping

객체와 관계형 데이터베이스의 데이터를 자동으로 매핑해주는 것

- 객체 지향 프로그래밍은 클래스를 사용하고, 관계형 데이터베이스는 테이블을 사용
- 객체 모델과 관계형 모델 간에 불일치가 존재
- ORM을 통해 객체 간의 관계를 바탕으로 SQL을 자동으로 생성하여 불일치를 해결

### ORM의 장점

- 객체 지향적 코드로 더 직관적이고 비즈니스 로직에 집중 가능
    - 부수적인 코드가 없거나 줄어듦
    - 각종 객체에 대한 코드를 별도로 작성하여 코드의 가독성 올려줌
    - 객체 지향적 접근을 통해 생산성 증가
- 재사용성 및 유지보수의 편리성 증가
    - ORM의 객체는 재사용 가능
    - 디자인패턴을 견고히 다지는데 유리
    - 매핑정보가 명확하여 ERD 의존도 낮출 수 있음

### ORM의 단점

- 완벽한 ORM으로만 서비스를 구현하기 어려움
    - 프로젝트의 복잡성 커질 경우 난이도 올라감
    - 잘못 구현 경우 문제 큼
- 프로시저가 많은 시스템에서는 ORM의 장점 활용 어려움

---

- ex. Prisma의 Connection Pool 관리 방법
    
    첫 쿼리 실행시 자동으로 커넥션 풀을 생성, Node.js 프로세스가 종료될 때 자동으로 끊어줌 - connect와 disconnect 직접 호출 필요 없음
    
    Primsa Client는 하나만 만들어서 재사용해야 함
    
- ex. Prisma의 Migration 관리 방법
    
    Prisma는 4가지의 상태로 migration 추적
    
    - Prisma 스키마 (소스 코드)
    - prisma/migrations 폴더의 SQL 파일
    - DB 안의 `_prisma_migrations`  테이블
    - 실제 DB 스키마
    
    ```tsx
    # 개발 중 스키마 변경 시 (migration 파일 생성 + DB 적용)
    npx prisma migrate dev --name 변경내용_설명
    
    # DB 초기화 (개발 환경에서만)
    npx prisma migrate reset
    
    # 프로덕션에 pending migration 적용
    npx prisma migrate deploy
    
    # migration 상태 확인
    npx prisma migrate status
    ```

---

## ORM 라이브러리의 예시
Flask: SQLAlchemy

Java: JPA

Django: 내장 ORM

---

## 페이지네이션을 사용하는 다른 API 찾아보기

우리 서비스:
- 지역별 가게 조회
- 완료된 미션 조회
등등

기존 서비스:
- 서점 사이트 베스트셀러 조회
- 네이버 카페 게시판 조회
등등..