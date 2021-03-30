# Project Manager Server API

## Thing 목록 받기

### Start line

| Method | URL  |Description|
| - | -|---|
| GET    | /things |모든 Thing을 불러온다.|

### Response

| Name | Type | Description | Required|
| -------- | -------- | -------- |---|
| id | Number(Unsigend 되면 Unsigned로 바꾸기) | Thing의 고유한 id 값 ||
| title | String | Thing의 제목 |Optional|
| description | String | Thing의 세부내용 |Optional|
| state | String or Number | Thing의 상태 ||
| due_date | Number | Thing의 기한 ||
| modification_date | Number | Thing이 수정된 날짜 |Optional|


#### Sample

```json
[
        {
            "todos": [
                {
                    "id": 1,
                    "title": "서버 환경설정",
                    "description": "Homebrew를 통해 Vapor Toolbox 설치하기",
                    "state": "todo",
                    "due_date": 1611523563.719116,
                    "modification_date": 1611523563.719116,
                }
            ]
        },
        {
            "doings": [
                {
                    "id": 2,
                    "title": "서버 API 문서 작성하기",
                    "description": null,
                    "state": "doing",
                    "due_date": 16115462413.28349,
                    "modification_date": 16115462413.28349,
                }
            ]
        },
        {
            "dones": [
            		{
                    "id": 3,
                    "title": "API 설계하기",
                    "description": null,
                    "state": "doing",
                    "due_date": 1611598271.28371,
                    "modification_date": 1611598271.28371,
                }
        		]
        }
]
```

## Thing 생성하기
### Request
##### Headers
| Content-Type                    | If-Modified-Since |
| ------------------------------- | ----------------- |
| application/json; charset=utf-8 |                   |
##### Body
| Name | Type | Description | Required|
| -------- | -------- | -------- | -------- |
|          |          |          |          |
|          |          |          |          |
|          |          |          |          |
|          |          |          |          |
|          |          |          |          |
## Thing 수정하기

## Thing 삭제하기


