@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    
    let jsonEncoder = JSONEncoder()
    let header: HTTPHeaders = ["Content-Type": "application/json; charset=utf-8"]
    
    struct TestItem: Content {
        var id: Int?
        var title: String
        var body: String
        var state: State
        var deadline: Double?
        var last_modified: Double?
    }
    
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
    
    func testPatchFailureCase() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        let item = Item(title: "New title", body: "New body", state: .doing, deadline: nil)
        let body = try jsonEncoder.encodeAsByteBuffer(item, allocator: ByteBufferAllocator())
        
        try app.test(.PATCH, "item", headers: header, body: body) { res in
            XCTAssertEqual(res.status, .notFound)
        }
    }
    
    func testPatchSuccessCase() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        let postItem = Item(title: "title", body: "body", state: .todo, deadline: nil)
        let postBody = try jsonEncoder.encodeAsByteBuffer(postItem, allocator: ByteBufferAllocator())
        
        try app.test(.POST, "item", headers: header, body: postBody) { res in
            XCTAssertEqual(res.status, .created)
            let postedItem = try res.content.decode(TestItem.self)
            let patchItem = EditedItem(title: "New title", body: nil, state: nil, deadline: nil)
            let patchBody = try jsonEncoder.encodeAsByteBuffer(patchItem, allocator: ByteBufferAllocator())
            if let id = postedItem.id {
                try app.test(.PATCH, "item/\(id)", headers: header, body: patchBody) { res in
                    XCTAssertEqual(res.status, .ok)
                }
            }
        }
    }

    func testDeleteFailureCase() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        try app.test(.DELETE, "items", afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
        })
    }
    
    func testDeleteSuccessCase() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)
        
        let postItem = Item(title: "title", body: "body", state: .todo, deadline: nil)
        let postBody = try jsonEncoder.encodeAsByteBuffer(postItem, allocator: ByteBufferAllocator())
        
        try app.test(.POST, "item", headers: header, body: postBody) { res in
            XCTAssertEqual(res.status, .created)
            if let id = postItem.id {
                try app.test(.DELETE, "item/\(id)?key=zziruru_taetae_cheer_up") { res in
                    XCTAssertEqual(res.status, .ok)
                }
            }
        }
    }
}
