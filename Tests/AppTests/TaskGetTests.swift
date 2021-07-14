//
//  TaskGetTests.swift
//  
//
//  Created by duckbok on 2021/07/14.
//

@testable import App
import XCTVapor

final class TaskGetTests: XCTestCase {
    var app: Application!

    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        try app.autoRevert().wait()
        try app.autoMigrate().wait()

        // given
        let tasks: [Task] = [
            Task(title: "TIL쓰기", deadline: Date(), state: .todo),
            Task(title: "회고하기", deadline: Date(), state: .todo, contents: "오늘도 즐거운 회고시간")
        ]

        for task in tasks {
            try task.save(on: app.db).wait()
        }

        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        app.shutdown()
        try super.tearDownWithError()
    }

    func test_Task목록_조회에_성공했을때_200상태코드와_함께_응답한다() throws {
        // when
        try app.test(.GET, Task.schema) { response in
            //then
            let responsedTasks = try response.content.decode([Task].self)
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(responsedTasks.count, 2)
        }
    }

    func test_다른_path에_GET요청을_한다면_404상태코드와_함께_에러를_응답한다() throws {
        // when
        try app.test(.GET, "hey") { response in
            //then
            let responsedTasks = try? response.content.decode([Task].self)
            XCTAssertEqual(response.status, .notFound)
            XCTAssertEqual(response.content.contentType, .json)
            XCTAssertNil(responsedTasks)
        }
    }
}
