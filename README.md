1. 프로젝트 관리앱을 여러 유저가 같은 게시글을 공유할지? 개인 마다 게시글을 각자 저장할지?

   → 개인이 쓰는 앱이라 생각하고 서버 제작

2. URL파라미터에서 sort순서를 서버쪽에서 제공할지 의논하기

   - 예시 : `[<https://sample-app.heroku.app/memos/1?sort_order=asc>](<https://sample-app.heroku.app/1?sort_order=asc>)`
   - 예시 : `[<https://sample-app.heroku.app/memos/1>](<https://sample-app.heroku.app/1?sort_order=asc>)`

   → 정렬 방법의 디폴트 값을 지정해놓고 클라에서 필요할 때마다 바꿔서 사용

3. TODO, DOING , DONE 마다 메모 갯수가 다른 데, 갯수를 서버쪽에서 타입을 나눠서 제공할지 클라에서 받아서 처리할지 의논하기 → 각각 전송받는 url 제작 `https://sample-app.heroku.app/memos/todo/1` = todo 메모만 받는 url

4. 페이지마다 최대한 보여줄 메모수 정하기 → 서버에서 limit , 클라에서 offset → todo, doing, done 각각 20개씩

   `[<https://sample-app.heroku.app/memos/todo/1?sortOrder=dsc&limit=20>](<https://sample-app.heroku.app/memos/todo/1?sortOrder=dsc&limit=20>)` → 20개씩, descending order로 받는 url

5. Naming 어떤지 의논하기 → OK

6. 전달받는, 전달하는 application 형식은 모두 json

7. REST API 문서 설계화는 `Swagger` 툴 사용

[Build, Collaborate & Integrate APIs | SwaggerHub](https://app.swaggerhub.com/apis-docs/Neph3779/Project_Manager/1.0.0)