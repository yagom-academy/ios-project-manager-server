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
}
