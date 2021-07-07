@testable import App
import XCTVapor

final class AppTests: XCTestCase {
    var app: Application!
    
    override func setUpWithError() throws {
        app = Application(.testing)
        try configure(app)
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        app.shutdown()
    }
}
