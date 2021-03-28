### 메모 파라미터 설명

| 파라미터    | 설명        | 타입                            |
| ----------- | ----------- | ------------------------------- |
| memos       | 메모 리스트 | object array                    |
| index       | 메모 인덱스 | string                          |
| title       | 제목        | string                          |
| description | 메모 본문   | string                          |
| date        | 마감일      | string                          |
| status      | 메모 상태   | string("todo", "doing", "done") |
| result      | 요청 결과   | bool                            |
| item        | 메모 내용   | object                          |



### Item 파라미터 설명

- item: object
    - index: string, 메모 인덱스
    - title: string, 제목
    - description: string, 메모 본문
    - date: string, 마감일
    - status: string("todo", "doing", "done"), 메모 상태



### 히스토리 파라미터 설명

| 파라미터     | 설명                       | 타입                             |
| ------------ | -------------------------- | -------------------------------- |
| histories    | 히스토리 내역              | object array                     |
| fromStatus   | 이전 메모 상태             | string?("todo", "doing", "done") |
| toStatus     | 이후 메모 상태             | string?("todo", "doing", "done") |
| behavior     | 메모 추가, 이동, 삭제 행위 | string                           |
| modifiedDate | 메모 추가, 이동, 삭제 시간 | string                           |



### status 파라미터 설명

| status  | 행위       |
| ------- | ---------- |
| "todo"  | todo 메모  |
| "doing" | doing 메모 |
| "done"  | done 메모  |



---

### 메모 조회

#### 메모 조회 요청 방식

- GET /memos

#### 메모 조회 응답 파라미터 예시

```json
[
    {
        "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AFF8",
        "title": "아침먹기",
        "description": "오늘의 아침은 순대국밥",
        "date": "2020-04-03T00:00:00Z",
        "status": "todo"
    },
    {
        "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AFF9",
        "title": "점심먹기",
        "description": "오늘의 점심은 서브웨이",
        "date": "2020-04-03T00:00:00Z",
        "status": "todo"
    }
    {
        "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AFF8",
        "title": "아침먹기",
        "description": "오늘의 아침은 순대국밥",
        "date": "2020-04-03T00:00:00Z",
        "status": "doing"
    },
    {
        "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AFF9",
        "title": "점심먹기",
        "description": "오늘의 점심은 서브웨이",
        "date": "2020-04-03T00:00:00Z",
        "status": "doing"
    }
    {
        "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AFF8",
        "title": "아침먹기",
        "description": "오늘의 아침은 순대국밥",
        "date": "2020-04-03T00:00:00Z",
        "status": "done"
    },
    {
        "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AFF9",
        "title": "점심먹기",
        "description": "오늘의 점심은 서브웨이",
        "date": "2020-04-03T00:00:00Z",
        "status": "done"
    }
]
```

---

### 메모 저장

#### 메모 저장 요청 방식

- POST /memo

#### 메모 저장 요청 파라미터 예시

```json
{
    "title": "아침먹기",
    "description": "오늘의 아침은 순대국밥",
    "date": "2020-04-03T00:00:00Z",
    "status": "todo"
}
```

#### 메모 저장 응답 파라미터 예시

```json
// POST /memo
// 200 OK
{
    "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AFF8",
    "title": "아침먹기",
    "description": "오늘의 아침은 순대국밥",
    "date": "2020-04-03T00:00:00Z",
    "status": "todo"
}
```

---

### 메모 수정

#### 메모 수정 요청 방식

- PATCH /memo/{index}

#### 수정 가능 파라미터(개별 요청 가능)

-   "title": 메모의 제목
-   "description": 메모의 본문
-   "date": 메모 마감일자
-   "status": 메모의 상태

#### 메모 수정 요청 파라미터 예시 1

```json
{
    "title": "아침먹기",
    "description": "오늘의 아침은 순대국밥",
    "status": "todo"
}
```

#### 메모 수정 응답 파라미터 예시 1

```json
// PATCH /memo/{index}
// 200 OK
{
    "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AF10",
    "title": "아침먹기",
    "description": "오늘의 아침은 순대국밥",
    "date": "2020-04-03T00:00:00Z",
    "status": "todo"
}
```

---

#### 메모 수정 요청 파라미터 예시 2

```json
{
    "description": "맛있는거 먹고 잘 쉬기",
}
```

#### 메모 수정 응답 파라미터 예시 2

```json
// PATCH /memo/{index}
// 200 OK
{
    "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AF10",
    "title": "아침먹기",
    "description": "맛있는거 먹고 잘 쉬기",
    "date": "2020-04-03T00:00:00Z",
    "status": "todo"
}
```

---

### 메모 삭제

#### 메모 삭제 요청 방식

DELETE /memo/{index}

#### 메모 삭제 응답 파라미터 예시

```json
// DELETE /memo/{index}
// 200 OK
{
    "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AF10",
    "title": "아침먹기",
    "description": "오늘의 아침은 순대국밥",
    "date": "2020-04-03T00:00:00Z",
    "status": "todo"
}
```

---

### 히스토리 요청

#### 히스토리 조회 요청 방식

- GET /history

#### 히스토리 조회 응답 파라미터 예시

```json
// GET /history
// 200 OK

[
    {
        "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AF10",
        "title": "Moved '아침먹기' from TODO to DOING.",
        "fromStatus": "todo",
        "toStatus": "doing",
        "behavior": "moved",
        "modifiedDate": "2020-04-03T00:00:00Z"
    },
    {
        "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AF10",
        "title": "Added '점심먹기'",
        "behavior": "added",
        "modifiedDate": "2020-04-03T00:00:00Z",
    },
    {
        "index": "48E2E85B-9FC4-4FA7-AE98-D0F2BE71AF10",
        "title": "Added '점심먹기'",
        "fromStatus": "done",
        "behavior": "removed",
        "modifiedDate": "2020-04-03T00:00:00Z",
    }
]
```

---

### 요청 실패 시 응답 내용

| 에러 내용                          | HTTP status code       |
| ---------------------------------- | ---------------------- |
| 유효하지 않은 요청할 경우          | 400 Bad Request        |
| 유효하지 않은 페이지를 요청할 경우 | 404 Not Found          |
| 허용하지 않은 메서드를 요청할 경우 | 405 Method Not Allowed |
| 요청 시간 아웃                     | 408 Request Timeout    |

### 에러 응답 파라미터 예시

```json
{
		"error":true,
		"reason":"Not Found",
}
```

-   error: 에러 발생 시 true 값 지정
-   reason: 에러 발생 이유 명시