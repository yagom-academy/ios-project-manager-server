//
//  TaskCreateTests.swift
//  
//
//  Created by duckbok on 2021/07/14.
//

@testable import App
import XCTVapor

final class TaskCreateTests: XCTestCase {
    var app: Application!

    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }

    func test_Task_등록이_성공했을때_201상태코드와_등록된_Task_정보가_반환된다() throws {
        // given
        let expectedTitle = "테스트 하기"
        let expectedDeadline = 1623412346.0
        let expectedState = "todo"
        let expectedContents = "공식 문서를 읽어보자"

        let task = Task(title: expectedTitle,
                        deadline: Date(timeIntervalSince1970: expectedDeadline),
                        state: State(rawValue: expectedState)!,
                        contents: expectedContents)

        try app.test(.POST, "tasks", beforeRequest: { request in
            // when
            try request.content.encode(task)
        }, afterResponse: { response in
            // then
            let responseTask = try response.content.decode(Task.self)
            XCTAssertEqual(response.status, .created)
            XCTAssertEqual(responseTask.id, 1)
            XCTAssertEqual(responseTask.title, expectedTitle)
            XCTAssertEqual(responseTask.deadline, Date(timeIntervalSince1970: expectedDeadline))
            XCTAssertEqual(responseTask.state, State(rawValue: expectedState)!)
            XCTAssertEqual(responseTask.contents, expectedContents)
        })
    }

    func test_contents가_없는_Task를_등록했을때_201상태코드와_contents가_null인_Task_정보가_반환된다() throws {
        // given
        let expectedTitle = "테스트 하기"
        let expectedDeadline = 1623412123.0
        let expectedState = "doing"

        let task = Task(title: expectedTitle,
                        deadline: Date(timeIntervalSince1970: expectedDeadline),
                        state: State(rawValue: expectedState)!)

        try app.test(.POST, "tasks", beforeRequest: { request in
            // when
            try request.content.encode(task)
        }, afterResponse: { response in
            // then
            let responseTask = try response.content.decode(Task.self)
            XCTAssertEqual(response.status, .created)
            XCTAssertEqual(responseTask.id, 1)
            XCTAssertEqual(responseTask.title, expectedTitle)
            XCTAssertEqual(responseTask.deadline, Date(timeIntervalSince1970: expectedDeadline))
            XCTAssertEqual(responseTask.state, State(rawValue: expectedState)!)
            XCTAssertNil(responseTask.contents)
        })
    }
    
    func test_유효하지않은_JSON형식으로_요청했을때_400상태코드를_반환한다() throws {
        // given
        let invalidJson: String = """
        {
            {}
            "title": "수지의 군기 잡기",
            "deadline": 1627016911,
            "state": "todo"
        }
        """
        
        try app.test(.POST, "tasks", beforeRequest: { request in
            // when
            request.headers.contentType = .json
            request.body.setString(invalidJson, at: 0)
        }, afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    func test_title글자수가_50자_초과일때_400상태코드를_반환한다() throws {
        // given
        let expectedTitle = "50자 넘는 테스트를 하려고 더미 데이터를 만듭니다. 가나다라마바사아자차카타파하 야곰캠프빨리끝내자~~~~~~~~~~~"
        
        let task = Task(title: expectedTitle,
                        deadline: Date(),
                        state: .todo)
        
        try app.test(.POST, "tasks", beforeRequest: { request in
            // when
            try request.content.encode(task)
        }, afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    func test_Task의_프로퍼티중_올바르지않은_타입으로_요청했을때_400상태코드를_반환한다() throws {
        // given
        let resquestData: [String: String] = ["title": "수지의 군기 잡기",
                                           "deadline": "1627016911",
                                           "state": "todo"]
        
        try app.test(.POST, "tasks", beforeRequest: { request in
            // when
            try request.content.encode(resquestData, as: .json)
        }, afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    func test_id를_넣어서_Task를_등록했을때_400상태코드를_반환한다() throws {
        // given
        let expectedTitle = "id추가"
        
        let task = Task(id: 1000,
                        title: expectedTitle,
                        deadline: Date(),
                        state: .todo)
        
        try app.test(.POST, "tasks", beforeRequest: { request in
            // when
            try request.content.encode(task)
        }, afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    func test_잘못된_url로_요청했을때_404상태코드를_반환한다() throws {
        // given
        let expectedTitle = "잘못된 url 요청"
        
        let task = Task(title: expectedTitle,
                        deadline: Date(),
                        state: .todo)
        
        try app.test(.POST, "tasks/1", beforeRequest: { request in
            // when
            try request.content.encode(task)
        }, afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .notFound)
        })
    }
    
    func test_잘못된_Content_Type으로_요청했을때_415상태코드를_반환한다() throws {
        // given
        let expectedTitle = "테스트 하기"
        let expectedDeadline = 1623412123.0
        let expectedState = "doing"

        let task = Task(title: expectedTitle,
                        deadline: Date(timeIntervalSince1970: expectedDeadline),
                        state: State(rawValue: expectedState)!)

        try app.test(.POST, "tasks", beforeRequest: { request in
            // when
            try request.content.encode(task)
            request.headers.contentType = .plainText
        }, afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .unsupportedMediaType)
        })
    }
    
}
