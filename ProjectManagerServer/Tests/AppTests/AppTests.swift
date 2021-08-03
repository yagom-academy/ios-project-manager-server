@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "hello", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "Hello, world!")
        })
    }
    
    // MARK: - Test GET Methods
    
    func testGetTodoTasks() throws {
        // given
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
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
    
    func testFailToGetTodoTasks() throws {
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
