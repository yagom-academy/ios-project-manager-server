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
    var oldTask: Task!
    var deadline: Date!

    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        try app.autoRevert().wait()
        try app.autoMigrate().wait()

        // given
        let deadline = Date(timeIntervalSince1970: 123456789)
        let task = Task(title: "제목", deadline: deadline, state: .todo)
        try task.save(on: app.db).wait()
        oldTask = try app.db.query(Task.self).all().wait().first!

        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        app.shutdown()
        deadline = nil
        oldTask = nil
        try super.tearDownWithError()
    }

    func test_Task_전체_수정_성공하면_200상태코드와_함께_응답한다() throws {
        // given
        let patchTask = PatchTask(title: "회고하기", deadline: Date(), state: .doing, contents: "회고는 너무 즐거워")

        // when
        try app.test(.PATCH, Task.schema + "/\(oldTask.id!)", beforeRequest: { request in
            try request.content.encode(patchTask)
        }, afterResponse: { response in
            // then
            let responsedTask = try response.content.decode(Task.self)
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(responsedTask.id, oldTask.id)
            XCTAssertEqual(responsedTask.title, patchTask.title)
            XCTAssertEqual(floor(responsedTask.deadline.timeIntervalSince1970), floor(patchTask.deadline!.timeIntervalSince1970))
            XCTAssertEqual(responsedTask.state, patchTask.state)
            XCTAssertEqual(responsedTask.contents, patchTask.contents)
            XCTAssertGreaterThan(responsedTask.lastModifiedDate!, oldTask.lastModifiedDate!)
        })
    }

    func test_Task_부분_수정_성공하면_200상태코드와_함께_응답한다() throws {
        // given
        let patchTask = PatchTask(title: nil, deadline: nil, state: .done, contents: nil)

        // when
        try app.test(.PATCH, Task.schema + "/\(oldTask.id!)", beforeRequest: { request in
            try request.content.encode(patchTask)
        }, afterResponse: { response in
            // then
            let responsedTask = try response.content.decode(Task.self)
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(responsedTask.id, oldTask.id)
            XCTAssertEqual(responsedTask.title, oldTask.title)
            XCTAssertEqual(responsedTask.deadline, oldTask.deadline)
            XCTAssertEqual(responsedTask.state, patchTask.state)
            XCTAssertEqual(responsedTask.contents, oldTask.contents)
            XCTAssertGreaterThan(responsedTask.lastModifiedDate!, oldTask.lastModifiedDate!)
        })
    }

    func test_같은_내용의_Task를_수정_요청하면_최종수정시간_변경없이_200상태코드와_함께_응답한다() throws {
        // given
        let patchTask = PatchTask(title: oldTask.title, deadline: oldTask.deadline, state: oldTask.state, contents: oldTask.contents)

        // when
        try app.test(.PATCH, Task.schema + "/\(oldTask.id!)", beforeRequest: { request in
            try request.content.encode(patchTask)
        }, afterResponse: { response in
            // then
            let responsedTask = try response.content.decode(Task.self)
            XCTAssertEqual(response.status, .ok)
            XCTAssertEqual(responsedTask.id, oldTask.id)
            XCTAssertEqual(responsedTask.title, oldTask.title)
            XCTAssertEqual(floor(responsedTask.deadline.timeIntervalSince1970), floor(oldTask.deadline.timeIntervalSince1970))
            XCTAssertEqual(responsedTask.state, oldTask.state)
            XCTAssertEqual(responsedTask.contents, oldTask.contents)
            XCTAssertEqual(responsedTask.lastModifiedDate!.timeIntervalSince1970, oldTask.lastModifiedDate!.timeIntervalSince1970)
        })
    }

    func test_프로퍼티의_타입이_잘못되었을때_400상태코드와_함께_응답한다() throws {
        // given
        let state = ["deadline": "asd1231aweqwea"]
        
        // when
        try app.test(.PATCH, Task.schema + "/1", beforeRequest: { request in
            try request.content.encode(state, as: .json)
        } ,afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .badRequest)
        })
    }

    func test_허용되지_않는_state로_수정요청을_했을때_400상태코드와_함께_응답한다() throws {
        // given
        let state = ["state": "hello"]
        
        // when
        try app.test(.PATCH, Task.schema + "/1", beforeRequest: { request in
            try request.content.encode(state, as: .json)
        } ,afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .badRequest)
        })
    }
    
    func test_존재하지_않는_id로_수정요청을_했을때_404상태코드와_함께_응답한다() throws {
        // given
        let patchTask = PatchTask(title: "회고하기", deadline: Date(), state: .doing, contents: "회고는 너무 즐거워")
        
        // when
        try app.test(.PATCH, Task.schema + "/1000", beforeRequest: { request in
            try request.content.encode(patchTask)
        } ,afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .notFound)
        })
    }
    
    func test_요청하는_url의_id가_유효하지_않으면_404상태코드와_함께_응답한다() throws {
        // given
        let invalidId = "/12sdf"
        
        // when
        try app.test(.PATCH, Task.schema + invalidId, afterResponse: { response in
            // then
            XCTAssertEqual(response.status, .notFound)
        })
    }
}
