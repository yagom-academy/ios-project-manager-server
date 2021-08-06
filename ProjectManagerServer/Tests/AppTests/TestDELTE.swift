@testable import App
import XCTVapor

/// Test DELTE Methods
final class TestDELTE: XCTestCase {
    var app: Application!
    
    override func setUpWithError() throws {
        
        // given
        app = try Application.testable()
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
    }
    
    func testDeleteTasks() throws {
        
        // given
        let task = Task(
            id: TaskStub.shared.expectedId,
            title: TaskStub.shared.expectedTitle,
            content: TaskStub.shared.expectedContent,
            deadline_date: TaskStub.shared.expectedDate,
            category: TaskStub.shared.expectedCategory
        )
        try task.save(on: app.db).wait()
        
        // when
        try app.test(.DELETE, "project/task/B60AC9A4-9D6B-489F-9373-F9A2412B818E", beforeRequest: { request in
            request.headers.contentType = .json
        }, afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .ok)
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
