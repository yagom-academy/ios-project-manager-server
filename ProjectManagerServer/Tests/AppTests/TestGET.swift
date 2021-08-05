@testable import App
import XCTVapor

/// Test GET Methods
final class TestGET: XCTestCase {
    var app: Application!
    
    override func setUpWithError() throws {
        
        app = try Application.testable()
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
    }
    
    func testTodoTasks() throws {
        
        // given
        let task = Task(
            id: nil,
            title: TaskStub.shared.expectedTitle,
            content: TaskStub.shared.expectedContent,
            deadline_date: TaskStub.shared.expectedDate,
            category: TaskStub.shared.expectedCategory
        )
        try task.save(on: app.db).wait()
        
        // when
        try app.test(.GET, "project/todo", afterResponse: { response in
            let todo = try response.content.decode([Task].self)
            
            // then
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.headers.contentType, .json)
            XCTAssertEqual(todo[0].category, .todo)
            XCTAssertNotNil(todo[0].id)
            XCTAssertNotEqual(todo[0].category, .doing)
            XCTAssertNotEqual(todo[0].category, .done)
        })
    }
    
    func testFailToTodoTasks() throws {
        
        // given
        let task = Task(
            id: nil,
            title: TaskStub.shared.expectedTitle,
            content: TaskStub.shared.expectedContent,
            deadline_date: TaskStub.shared.expectedDate,
            category: TaskStub.shared.expectedCategory
        )
        try task.save(on: app.db).wait()
        
        // when
        try app.test(.GET, "project/invalidURL", afterResponse: { response in
            
            // then
            XCTAssertEqual(response.status, .notFound)
        })
    }
}
