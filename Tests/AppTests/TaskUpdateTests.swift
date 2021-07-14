//
//  TaskUpdateTests.swift
//  
//
//  Created by duckbok on 2021/07/14.
//

@testable import App
import XCTVapor

final class TaskUpdateTests: XCTestCase {
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

    func test_Task_전체_수정_성공하면_200상태코드와_함께_응답한다() throws {
        // given
        let id: Int = 1
        let patchTask = PatchTask(title: "회고하기", deadline: Date(), state: .doing, contents: "회고는 너무 즐거워")

        // when
        try app.test(.PATCH, Task.schema + "/\(id)", beforeRequest: { request in
            try request.content.encode(patchTask)
        }, afterResponse: { response in
            // then
            let responsedTask = try response.content.decode(Task.self)
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(responsedTask.id, id)
            XCTAssertEqual(responsedTask.title, patchTask.title)
            XCTAssertEqual(responsedTask.deadline, patchTask.deadline)
            XCTAssertEqual(responsedTask.state, patchTask.state)
            XCTAssertEqual(responsedTask.contents, patchTask.contents)
        })
    }

    func test_Task_부분_수정_성공하면_200상태코드와_함께_응답한다() throws {
        // given
        let id: Int = 1
        let patchTask = PatchTask(title: nil, deadline: nil, state: .done, contents: nil)

        // when
        try app.test(.PATCH, Task.schema + "/\(id)", beforeRequest: { request in
            try request.content.encode(patchTask)
        }, afterResponse: { response in
            // then
            let responsedTask = try response.content.decode(Task.self)
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(responsedTask.id, id)
            XCTAssertEqual(responsedTask.state, patchTask.state)
        })
    }
}
