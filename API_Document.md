# API Document

- Base URI: https://project-manager-server-app.herokuapp.com

## 할 일 전체 조회

- `Method`: GET
- `Path`: /todos
- `HTTP Status Code`
    - Success: 200
    - Error: 400, 404, 500

| Response Body                   ||
| ------------ | ----------------- |
| === JSON Object ===             ||
| todoList     | Object Array      |
| === JSON Object ===             ||
| id           | Number            |
| title        | String            |
| description  | String (Optional) |
| deadline     | Date (Optional)   |
| status       | Number            |

### Success data sample

~~~swift

[
    {
        "id": 1,
        "title": "태태의 볼펜 똥 채우기",
        "description": "볼펜 똥이 다 떨어져서 볼펜 똥을 오픈마켓에서 사오자",
        "deadline": "2021-11-21T00:00:00Z",
        "status": 0,
    },
    {
        "id": 2,
        "title": "오동나무 물주기",
        "description": "오동나무 물은 일주일에 3번씩 화요일날 주어야한다!",
        "deadline": "2021-11-21T00:00:00Z",
        "status": 1,
    },
    {
        "id": 3,
        "title": "라자냐 먹기",
        "description": "오늘 저녁은 라자냐를 먹어야겠다,,",
        "deadline": "2021-11-21T00:00:00Z",
        "status": 2,
    }
]
~~~

### Error data sample

~~~swift
{
  "error": true
}
~~~



## 할 일 조회

- `Method`: GET
- `Path`: /todo/:id
- `HTTP Status Code`
    - Success: 200
    - Error: 400, 404, 500

| Response Body                   ||
| ------------ | ----------------- |
| === JSON Object ===             ||
| id           | Number            |
| title        | String            |
| description  | String (Optional) |
| deadline     | Date (Optional)   |
| status       | Number            |



## 할 일 등록

- `Method`: POST
- `Path`: /todo
- `HTTP Status Code`
    - Success: 201
    - Error: 400, 404, 500

| Request Body                    || | Response Body                   ||
| -----------  | ----------------- |-| ------------ | ----------------- |
| === JSON Object ===             || | === JSON Object ===             ||
| -            | -                 | | id           | Number            |
| title        | String            | | title        | String            |
| description  | String (Optional) | | description  | String (Optional) |
| deadline     | Date (Optional)   | | deadline     | Date (Optional)   |
| status       | Number            | | status       | Number            |



## 할 일 수정

- `Method`: PATCH
- `Path`: /todo/:id
- `HTTP Status Code`
    - Success: 200
    - Error: 400, 404, 500

| Request Body                    || | Response Body                   ||
| -----------  | ----------------- |-| ------------ | ----------------- |
| === JSON Object  ===            || | === JSON Object  ===            ||
| -            | -                 | | id           | Number            |
| title        | String (Optional) | | title        | String            |
| description  | String (Optional) | | description  | String (Optional) |
| deadline     | Date (Optional)   | | deadline     | Date (Optional)   |
| status       | Number (Optional) | | status       | Number            |

## 할 일 삭제

- `Method`: DELETE
- `Path`: /todo/:id
- `HTTP Status Code`
    - Success: 200
    - Error: 400, 404, 500

| Response Body                   ||
| ------------ | ----------------- |
| === JSON Object  ===            ||
| id           | Number            |
| title        | String            |
| description  | String (Optional) |
| deadline     | Date (Optional)   |
| status       | Number            |