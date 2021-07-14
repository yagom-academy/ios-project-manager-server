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

        // given
        let task = Task(title: "제목", deadline: Date(), state: .todo)
        try task.save(on: app.db).wait()

        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        app.shutdown()
        try super.tearDownWithError()
    }

    func test_Task_삭제가_성공했을때_204상태코드와_함께_task가_삭제된다() throws {
        // when
        try app.test(.DELETE, "/tasks/1", afterResponse: { response in
            // then
            let isDeleted: Bool = try app.db.query(Task.self).all().wait().isEmpty
            XCTAssertTrue(isDeleted)
            XCTAssertEqual(response.status, .noContent)
        })
    }

    func test_삭제요청한_ID의_Task가_없다면_404상태코드와_함께_에러를_응답한다() throws {
        // when
        try app.test(.DELETE, "/tasks/2", afterResponse: { response in
            // then
            let isDeleted: Bool = try app.db.query(Task.self).all().wait().isEmpty
            XCTAssertTrue(!isDeleted)
            XCTAssertEqual(response.status, .notFound)
        })
    }

    func test_삭제요청한_ID가_숫자가_아니라면_400상태코드와_함께_에러를_응답한다() throws {
        // when
        try app.test(.DELETE, "/tasks/abc", afterResponse: { response in
            // then
            let isDeleted: Bool = try app.db.query(Task.self).all().wait().isEmpty
            XCTAssertTrue(!isDeleted)
            XCTAssertEqual(response.status, .notFound)
        })
    }
}
