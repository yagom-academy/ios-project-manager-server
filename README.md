# 프로젝트 관리 앱(서버)

<br>

## 📘 STEP 1 : API 설계 및 문서화
- [API 문서](https://docs.google.com/spreadsheets/d/1_nDj5blrLfcHYRtEE_4KGOhiH57aKL6oBPPHIcJK4yE/edit#gid=0)
### 1. [API 문서](https://docs.google.com/spreadsheets/d/1_nDj5blrLfcHYRtEE_4KGOhiH57aKL6oBPPHIcJK4yE/edit)
   - `id`의 값을 `uuid`로 관리하기 위해 타입을 `int → String`으로 변경. 
#### GET
> 목록을 조회할 때 해당 상태에 따라 조회 가능하게 `status` 키값을 활용하였습니다.
- Response Body
  ```swift
  - id: String
  - title: String
  - description: String
  - deadline: Int
  - status: String
  ```
#### POST
> POST할 때 `status`값은 "todo"로만 요청하도록 클라이언트 측과 협의예정입니다.
- Request Body
  ```swift
  - title: String
  - description: String
  - deadline: Int
  - status: String = "todo"
  ```
- Response Body
  ```swift
  - id: String
  - title: String
  - description: String
  - deadline: Int
  - status: String = "todo"
  ```
#### PATCH
> cell 수정 및 drag and drop, 2가지를 고려하여 `status` 값을 포함하였습니다.
- Request Body
  ```swift
  - id: String
  - title: String
  - description: String
  - deadline: Int
  - status: String
  ```
- Response Body
  ```swift
  - id: String
  - title: String
  - description: String
  - deadline: Int
  - status: String
  ```
#### DELETE
> 개인서버라고 생각하여 비밀번호 없이도, `id`의 키값만으로도 삭제하고자 하였습니다.
- Request Body
  ```swift
  - id: String
  ```

<br>

## 📕 STEP 1 고민사항
1. 현재 API 문서는 lowerCamelCase로 작성하였습니다. 현재는 클라이언트도 Camel Case에 익숙한 상황이지만, 일반적인 상황에서 API 문서를 작성할 때, 표준으로 작성해야 하는 표기법이 있는지 궁금합니다🧐
2. `GET` Method 사용 시, `status` 값으로만 구별되게 하였습니다. 이렇게 하면 클라이언트 측에서 전체 데이터를 Parsing하고, 그 데이터를 배열에 담는 작업을 해야 해서, 번거로울 것 같다고 생각하였습니다. 더 나은 방향이 있을까요?
3. `DELETE` Method 사용 시, URL만 알고 있다면 타 사용자도 삭제할 수 있는 일이 벌어질 수 있다고 생각합니다. 이 부분에서 보안을 어떻게 처리해주면 좋을지 궁금합니다😆
<br>

### [답변](https://github.com/yagom-academy/ios-project-manager-server/pull/35#issuecomment-884658035)
1. 표준으로 작성해야 하는 표기법은 없고, 서로 약속하는 방식을 따르는게 더 중요하다고 생각해요. 제가 겪어본 바로는 작년에 서버 구현은 snake case 를 쓰다가 이번에 개편되면서 camel case 로 전환하기도 하더라구요. API 문서를 작성하는 표준은 따로 없다고 봐도 무방할 것 같아요. 룰은 같이 만들어가는거죠 😉
2. status 값으로만 구별되는게 번거롭다고 생각한 이유가 뭔가요? 다시 클라이언트에서 status 별로 나누는 작업이 필요해서 그렇게 생각한건가요? 클라이언트에서의 작업을 최소화 해주려면 todo, doing, done 으로 묶어서 배열을 내려주는 방법은 어떨까요?
3. REST api 의 authentication 에 대해 여러가지 알아보면 좋을 것 같아요. 익숙할지 모르겠지만 토큰 방식도 그중 한가지고요. 제가 사용해본 open api 에서는 access key 를 지급하고 query 에 항상 넘겨주는 방식을 사용하기도 했어요. 혹은 여기 나온 Authentication Mechanisms 도 참조하면 도움이 될 것 같네요. 혹은 hmac 이라는 방식도 쓰는데 한번 알아만 보셔도 좋을 것 같아요. 요건 api 경로에 hmac 을 추가하고 hash 값으로 인증된 사용자인지 판단하는 방식이에요. 제 생각엔 토큰이나 간단한 access key 정도가 좋을 것 같네요!

<br><br>

## 📘 STEP 2 : 프로젝트 생성 및 배포

### 1. Heroku 배포 결과
   - [It's work](https://sukio-tasks-management.herokuapp.com/) / [Hello, world!](https://sukio-tasks-management.herokuapp.com/hello)

### 2. Database 설계 구조 (ERD)
![스크린샷 2021-07-29 오후 7 32 34](https://user-images.githubusercontent.com/65153742/127481198-9b841140-6121-4797-bb2e-2a1d7fdcb6b8.png)

### 3. Database Table
![스크린샷 2021-07-29 오후 6 44 08](https://user-images.githubusercontent.com/65153742/127481372-c2216a1f-a8c5-494c-bf54-966fbe46ddc2.png)
- skdb == sooji + Kio + Database

<br>

## 📕 STEP 2 고민사항
1. uuid
- `id`를 고유키로 관리하기 위해 `uuid`를 생각하고, 데이터 타입으로 `string`으로 결정하였는데, 메모리 관점에서 안 좋은 방법으로 알고 있습니다. `id`를 관리하기에 효율적인 방법일지 궁금합니다😁


2. Migration
- `vapor run migrate`는 로컬상에서 데이터베이스에 올릴 때 사용하고, `heroku run Run -- migrate --env production`은 최초 단 한번만 사용하고, 이후 업데이트시마다 heroku push를 통해 하면 된다고 알고 있습니다. 위의 과정에서 heroku migrate가 하는 역할과 vapor, heroku의 2곳에서 `Migrate` 명령어를 사용할 수 있는데 정확히 어떤 차이점을 가지고 있는지 잘 이해하지 못하여 조언을 구하고 싶습니다😭 

### [답변](https://github.com/yagom-academy/ios-project-manager-server/pull/42#pullrequestreview-719038571)
1. varchar vs text 요 stackoverflow 의 맨 첫 답변 참고하시면 좋을 것 같습니다. char도 결국에 해당 공간을 다 사용하지 못하면 낭비일 수 있는 단점을 가지고 있고요, 지금 상태에서는 varchar 로 다루는게 가장 최선이지 않을까 싶어요.

<br><br>

## 📘 STEP 3 : API 구현
### 1. DATABASE CRUD 응답
#### Create
> ![스크린샷 2021-08-06 오전 11 33 35](https://user-images.githubusercontent.com/65153742/128447920-105a30ac-bce5-483b-af3c-65dfeff4bccf.png)
#### Read
> ![스크린샷 2021-08-06 오전 11 36 48](https://user-images.githubusercontent.com/65153742/128447930-70adc495-6a41-4e8f-b205-8b70ede07214.png)
#### Update
> ![스크린샷 2021-08-06 오전 11 38 36](https://user-images.githubusercontent.com/65153742/128447934-a1d37779-9abc-4ee5-af3f-24eca8ed0b6e.png)
#### Delete
> ![스크린샷 2021-08-06 오전 11 39 38](https://user-images.githubusercontent.com/65153742/128447951-f2593dbc-d58b-4cce-b032-da13438a1057.png)
> ![스크린샷 2021-08-06 오전 11 41 57](https://user-images.githubusercontent.com/65153742/128447975-d6b80eaf-4f90-4f46-8cfb-8e557523de3c.png)

<br>

### 2. Validation
#### Create
> ![스크린샷 2021-08-06 오전 11 54 42](https://user-images.githubusercontent.com/65153742/128449090-d4c57a40-4172-4182-a36b-fb8e0f34fb64.png)
#### Update
> ![스크린샷 2021-08-06 오전 11 56 05](https://user-images.githubusercontent.com/65153742/128449199-890b4863-9087-4e58-84c9-a20f17433484.png)
#### Delete
> ![스크린샷 2021-08-06 오후 12 12 39](https://user-images.githubusercontent.com/65153742/128450511-6ccc44b8-3ec9-4891-a789-0931d9ce3e55.png)


<br><br>

## 📕 STEP 3 고민사항
1. `POST` 할 때 모델에 선언한 프로퍼티 말고, 무작위 프로퍼티를 요청해도, Error를 발생시키지 않고, DB에 등록이 되는데 Validation으로 구현하려고 해봤지만 방법을 찾을 수 없었습니다. 고민해보아야 할 부분
> ![스크린샷 2021-08-06 오후 12 15 39](https://user-images.githubusercontent.com/65153742/128450719-c7adb27b-7603-4260-8fe8-5e0bebb77896.png)

<br><br><br>

# 프로젝트 진행 및 참고사항

### ⏰ 타임라인

#### 07.19~07.25
- [팀그라운드룰 작성](https://github.com/Kioding/ios-project-manager-server/blob/2dba3ca35307af6d3fb699ae21a8413ae0d25a82/Docs/%ED%8C%80%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C%EB%A3%B0.md)
- REST API
- vapor
- Heroku
#### 07.26~08.01
- Database Model 정의 및 migration
- Swift-server-side-framework
- RDMS(SQL) / NoSQL
- Vapor framework(Fluent)
- PostgreSQL
- Heroku 서버 배포
#### 08.02~08.08
- API 구현에 필요한 인코딩/디코딩 타입
- 데이터베이스 CRUD 구현
- CRUD DTO 
- Error 커스터마이징

<br>
<br>

### 🚀 트러블슈팅 (Troubleshooting)
- [Fatal error: Error raised at top level: bind(descriptor:ptr:bytes:) failed: Address already in use (errno: 98)](https://github.com/vapor/toolbox/issues/238)
   - `sudo lsof -i :8080 -sTCP:LISTEN |awk 'NR > 1 {print $2}'|xargs kill -15`
8080포트를 킬하니 되었다.
- ['heroku' does not appear to be a git repositor](https://alreadyusedadress.tistory.com/51)
   - `git init`, `heroku login`, `git remote` 까지 해주니 작동!
- [xcrun: error: unable to find utility “xctest”, not a developer tool or in PATH](https://stackoverflow.com/questions/61501298/xcrun-error-unable-to-find-utility-xctest-not-a-developer-tool-or-in-path)
Fatal error: result 1: file VaporToolbox/exec.swift, line 55
[1]    6858 illegal hardware instruction  vapor run migrate
- [[ WARNING ] connection reset (error set): Connection refused (errno: 111)
Fatal error: Error raised at top level: connection reset (error set): Connection refused (errno: 111): file Swift/ErrorType.swift, line 200](https://stackoverflow.com/questions/55205247/vapor-connection-refused-errno-61)
- git pull error: The following untracked working tree files would be overwritten by merge
    - [대안1](https://github.com/avast/retdec/issues/92)
    - [대안2](https://stackoverflow.com/questions/17989165/git-checkout-master-error-the-following-untracked-working-tree-files-would-be-o)

- [heroku 에서 git push heroku master 에러 나는 경우](https://velog.io/@jangky000/Heroku-%EB%B0%B0%ED%8F%AC)
- `POSTMAN GET 오류`
{ "error": true, "reason": "invalid field: deadline type: Int error: `typeMismatch`(Swift.Int, Swift.DecodingError.Context(codingPath: [], debugDescription: "Could not convert to Int: 123145215.0", underlyingError: nil))" }
   - 자료형을 바꾸고 vapor revert를 안해줘서 생긴 오류였다.
   - `vapor run migrate --revert`하고 `vapor run migrate` 을 다시 해주니 정상 작동
   
<br>
<br>

### 📝 메모

<details>
<summary>API문서 참고사항</summary>
<div markdown="1">

- [Postman API documentation](https://documenter.getpostman.com/view/15740314/Tzm3nd22) - 스티븐, 덕복
- [API 문서 - Fezz, JM](https://docs.google.com/spreadsheets/d/1PTOGFh9kAbBUtQZ0pqC8j2-oCjURtjUnjwxA2t6TlAU/edit#gid=0)
- [API 문서 - Sooji, Kio](https://docs.google.com/spreadsheets/d/1_nDj5blrLfcHYRtEE_4KGOhiH57aKL6oBPPHIcJK4yE/edit?usp=sharing)
- API 문서 - 수킴, Hailey, Neph
- API 관리 도구
    - swagger(유료)
    - postman
- URL
    - [https://sukio-tasks-management.herokuapp.com/](https://sukio-tasks-management.herokuapp.com/)
</details>
<br>
<br>

### 🔗 참고 링크

<details>
<summary>참고 링크 세부사항</summary>
<div markdown="1">


공식문서
- [VAPOR](https://github.com/vapor/vapor)
- [Heroku](https://www.heroku.com)

Vapor
- [VAPOR](https://github.com/vapor/vapor)
- [[야곰닷넷] Server-Side Swift with Vapor](https://yagom.net/courses/start-vapor/)
- [homebrew 설치](https://brew.sh/index_ko)
- [[블로그] [Vapor/Swift] Heroku를 이용하여 Vapor 서버 배포하기 - Ryan](https://velog.io/@ryan-son/VaporSwift-Vapor%EC%99%80-Heroku%EB%A5%BC-%EC%9D%B4%EC%9A%A9%ED%95%9C-REST-API-%EA%B5%AC%EC%84%B1-%EB%B0%8F-%EB%B0%B0%ED%8F%AC)
- [[블로그] Server-Side Swift with Vapor - Zedd](https://zeddios.tistory.com/957)
- [[유투브] Hello Vapor 4 (Server Side Swift) - asamsharp](https://www.youtube.com/watch?v=kJ1YS0NCHDI&t=841s)

Postman
- [[TIL] Postman으로 API문서 만들기](https://velog.io/@jinee/TIL-Postman%EC%9C%BC%EB%A1%9C-API%EB%AC%B8%EC%84%9C-%EB%A7%8C%EB%93%A4%EA%B8%B0-l4k5mj31rl)
  
API
- [[유투브] REST API가 뭔가요?](https://www.youtube.com/watch?v=iOueE9AXDQQ)
- [[유투브] Day1, 2-2. 그런 REST API로 괜찮은가](https://www.youtube.com/watch?v=RP_f5dMoHFc&t=1553s)
 
RDMS(SQL) / NoSQL
- [[유투브] 아직도 SQL을 모른다고해서 5분 설명해드림 - 노마드 코더](https://www.youtube.com/watch?v=z9chRlD1tec&t=176s)
- [[TablePlus] Postgres vs PostgreSQL - What is the difference?](https://tableplus.com/blog/2018/10/postgres-vs-postgresql.html)
- [[유투브] Decimal/Float, Char/Varchar/Text/Blob, Datetime/Timestamp - MySQL의 헷갈리는 자료형들](https://www.youtube.com/watch?v=NmraFRrusD8)
- [[유투브] 비전공자를 위한 SQL 입문서! | 쉽게 배우는 SQL! | 에어클래스](https://www.youtube.com/watch?v=MJsOoA8yM7A&t=1436s)

타임 스탬프 변환기
- [타임 스탬프 변환기](https://ko.rakko.tools/tools/29/)
 
</details>
