@testable import App
import XCTVapor

/// Test POST Methods
final class TestPOST: XCTestCase {
    var app: Application!
    
    override func setUpWithError() throws {
        
        // given
        app = try Application.testable()
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
    }
    
    func testPostTasks() throws {
        // when
        let task = Task(id: nil, title: "test", content: "testest", deadline_date: Date(), category: .todo)

        try app.test(.POST, "project/task", beforeRequest: { request in
            try request.content.encode(task)
        }, afterResponse: { response in
            let result = try response.content.decode(Task.self)
            
            // then
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.headers.contentType, .json)
            XCTAssertEqual(result.category, .todo)
            XCTAssertNotNil(result.id)
            XCTAssertNotEqual(result.category, .doing)
            XCTAssertNotEqual(result.category, .done)
        })
    }
    
    func testFailToPostTasks() throws {
        // given
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        // when
        try app.test(.GET, "project/invalidURL", afterResponse: { response in
            
            // then
            XCTAssertEqual(response.status, .notFound)
        })
    }
}
