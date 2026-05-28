1. 인증(Authentication)과 인가(Authorization)
인증 (Authentication): 사용자가 '누구'인지 확인하는 과정 (예: 로그인 과정).

인가 (Authorization): '인증된' 사용자가 특정 리소스에 접근하거나 동작을 수행할 권한이 있는지 확인하고 허가하는 과정.

💡 흐름: 항상 1st 인증 → 2nd 인가 순서로 진행됩니다. (로그인을 해야 마이페이지 접근 권한이 생김)

2. 인증 구현 방식: 세션(Session) vs 토큰(JWT)
세션 (Session) 방식
작동 원리: 서버가 사용자의 로그인 상태(세션 데이터)를 서버의 메모리나 DB에 직접 저장하고 관리합니다.

과정: 로그인 성공 → 서버에 정보 저장 및 Session ID 생성 → 클라이언트에게 쿠키로 Session ID 발급 → 클라이언트는 API 요청 시 쿠키를 동봉 → 서버가 Session ID를 대조하여 사용자 확인.

한계점: 서버 메모리를 차지하며, 서버를 여러 대(Scale-out)로 늘릴 경우 세션 불일치 문제가 발생할 수 있습니다. 쿠키 탈취 시 세션 하이재킹 위험이 존재합니다.

JWT (JSON Web Token) 방식
작동 원리: 세션처럼 서버가 상태를 기억하지 않는 무상태성(Stateless)을 가집니다. 사용자 식별 정보를 담은 JSON 객체를 '암호화 서명'하여 클라이언트에게 넘겨주고, 클라이언트가 이를 보관합니다.

구조 (Header.Payload.Signature):

Header (헤더): 토큰의 타입(JWT)과 서명 알고리즘(예: HS256, RS256) 정보.

Payload (페이로드): userId: 1, role: "admin" 등 실제 사용자를 식별할 수 있는 데이터(Claim). 단, 암호화되지 않으므로 비밀번호 등 민감 정보는 절대 넣으면 안 됩니다.

Signature (서명): 토큰이 위조되지 않았음을 증명하는 부분. 서버가 가진 '비밀 키(Secret Key)'를 이용해 헤더와 페이로드를 해싱하여 만듭니다. 서버는 요청이 오면 이 서명만 검증하여 신뢰성을 판단합니다.

토큰의 종류 (보안성 강화):

Access Token ("단기 출입증"): 수명이 짧으며(보통 30분~1시간), 실제 API 요청(게시글 작성, 정보 조회 등)에 매번 사용됩니다. 탈취당해도 피해를 최소화하기 위해 수명을 짧게 둡니다.

Refresh Token ("재발급용 카드"): 수명이 길며(보통 1주~2주), 만료된 Access Token을 새로 발급받을 때만 사용됩니다. 탈취 방지를 위해 DB나 안전한 저장소(HTTP Only 쿠키 등)에 보관합니다.

3. Bearer Token (토큰 전달 방식)
개념: HTTP 인증 체계(Authentication scheme) 중 하나로, "이 토큰을 가진 자(Bearer)에게 권한을 부여하라"는 의미입니다.

사용법: JWT나 OAuth 액세스 토큰을 클라이언트에서 서버로 보낼 때, HTTP 요청 헤더의 Authorization 필드에 아래와 같은 형식으로 담아 보냅니다.

HTTP
Authorization: Bearer <당신의_JWT_Access_Token_문자열>
특징: Bearer 방식은 토큰 자체가 권한을 증명하므로, 이 토큰을 탈취한 누구라도 권한을 행사할 수 있습니다. 따라서 반드시 HTTPS 통신 위에서 안전하게 전달되어야 합니다.

4. OAuth 2.0 (권한 위임 프로토콜)
개념: 우리가 흔히 아는 '소셜 로그인(구글, 카카오, 네이버로 로그인)'을 구현할 때 사용하는 표준 프로토콜입니다.

핵심 원리: 사용자가 우리 서비스에 비밀번호를 직접 제공하지 않고도, 신뢰할 수 있는 외부 서버(구글, 카카오)의 계정 정보를 이용해 안전하게 권한을 위임(Delegated Authorization)받는 방식입니다.

주요 구성 요소:

Resource Owner: 사용자 (구글 계정을 가진 사람).

Client: 우리가 개발하고 있는 서비스 (앱/웹).

Authorization Server: 권한을 검증하고 Access Token을 발급해 주는 서버 (구글 인증 서버).

Resource Server: 사용자의 정보(이름, 이메일 등)를 가지고 있는 서버 (구글 API 서버).

동작 흐름 요약:

사용자가 우리 앱에서 "구글로 로그인" 버튼 클릭.

구글 로그인 페이지로 이동하여 로그인 및 '정보 제공 동의' 완료.

구글(Authorization Server)이 우리 앱(Client)으로 '인가 코드(Authorization Code)'를 전달.

우리 앱의 백엔드 서버가 인가 코드를 구글에 다시 보내 Access Token을 발급받음.

발급받은 구글의 Access Token을 이용해 구글 API(Resource Server)에서 사용자의 이메일 등을 가져옴.

가져온 정보를 바탕으로 우리 앱 전용 JWT(Access/Refresh Token)를 생성하여 클라이언트에게 발급.