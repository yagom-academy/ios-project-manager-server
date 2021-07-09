//
//  Application+Testable.swift
//  
//
//  Created by Ryan-Son on 2021/07/08.
//

@testable import App
import XCTVapor

extension Application {
    static func testable() throws -> Application {
        let app = Application(.testing)
        try configure(app)
        
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        
        return app
    }
}
