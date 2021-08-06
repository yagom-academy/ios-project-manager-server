@testable import App
import XCTVapor

/// Test PATCH Methods
final class TestPATCH: XCTestCase {
    var app: Application!
    var oldTask: Task!
    
    override func setUpWithError() throws {
        app = try Application.testable()
        
        // given
        let task = Task(id: nil, title: "수정하기전 제목", content: nil, deadline_date: Date(), category: .doing)
        try task.save(on: app.db).wait()
        oldTask = try app.db.query(Task.self).all().wait().first!
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
        oldTask = nil
    }
    
    func testPatchTasks() throws {
        
        // given
        let updatedTask = TaskForPatch(title: "강경이 수정한 이름", content: nil, deadline_date: Date(), category: nil)

        print("project/task/\(oldTask.id!.uuidString)")
        // when
        try app.test(.PATCH, "project/task/\(oldTask.id!.uuidString)", beforeRequest: { request in
            try request.content.encode(updatedTask)
        }, afterResponse: { response in
            let result = try response.content.decode(Task.self)
            
            // then
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(response.headers.contentType, .json)
            XCTAssertEqual(result.category, nil)
            XCTAssertNotEqual(result.category, .doing)
            XCTAssertNotEqual(result.category, .done)
        })
    }
}
