@testable import App
import XCTVapor

final class AppTests: XCTestCase {
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
}
