//
//  TaskDeleteTests.swift
//  
//
//  Created by duckbok on 2021/07/07.
//

@testable import App
import XCTVapor

final class TaskDeleteTests: XCTestCase {
    var app: Application!

    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        app.shutdown()
        try super.tearDownWithError()
    }

    func test_Task_삭제가_성공했을때_204상태코드와_함께_task가_삭제된다() throws {
        // given
        let task = Task(title: "제목", deadline: Date(), state: .todo)
        try task.save(on: app.db).wait()

        // when
        try app.test(.DELETE, "/tasks/1", afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .noContent)
            try app.test(.GET, "/tasks", afterResponse: { response in
                let tasks = try response.content.decode([Task].self)
                XCTAssertTrue(tasks.isEmpty)
            })
        })
    }
}
