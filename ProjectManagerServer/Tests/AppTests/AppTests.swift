@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    func testHelloWorld() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "things", afterResponse: { request in
            XCTAssertEqual(request.status, .ok)
            XCTAssertEqual(request.content.contentType, .json)
        })
    }
}
