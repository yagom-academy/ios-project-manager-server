@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    
    let jsonEncoder = JSONEncoder()
    let header: HTTPHeaders = ["Content-Type": "application/json; charset=utf-8"]
    
    func testGetSuccessCase() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "items", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

    func testGetFailureCase() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let invalidURI = "item"
        try app.test(.GET, invalidURI, afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
        })
    }

    func testPostSuccessCase() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let item = Item(title: "title", body: "body", state: .todo, deadline: nil)
        let body = try jsonEncoder.encodeAsByteBuffer(item, allocator: ByteBufferAllocator())
        
        try app.test(.POST, "item", headers: header, body: body) { res in
            XCTAssertEqual(res.status, .created)
        }
    }

    func testPostFailureCase_longTitle() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let longTitle = "title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. title이 500자 이상이면 post할 수 없습니다. "
        let item = Item(title: longTitle, body: "body", state: .todo, deadline: nil)
        let body = try jsonEncoder.encodeAsByteBuffer(item, allocator: ByteBufferAllocator())
        
        try app.test(.POST, "item", headers: header, body: body) { res in
            XCTAssertEqual(res.status, .badRequest)
        }
    }
    
    func testPostFailureCase_longBody() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        let longBody = "Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다. Body가 1000자 이상이면 post할 수 없습니다."
        let item = Item(title: "title", body: longBody, state: .todo, deadline: nil)
        let body = try jsonEncoder.encodeAsByteBuffer(item, allocator: ByteBufferAllocator())
        
        try app.test(.POST, "item", headers: header, body: body) { res in
            XCTAssertEqual(res.status, .badRequest)
        }
    }

    func testPatchSuccessCase() throws {
        
    }

    func testPatchFailureCase() throws {
        
    }

    func testDeleteSuccessCase() throws {
        
    }

    func testDeleteFailureCase() throws {
        
    }
}
