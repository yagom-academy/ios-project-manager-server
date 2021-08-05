//
//  Extension.swift
//  
//
//  Created by KangKyung, James on 2021/08/05.
//

import XCTVapor
import App

extension Application {
  static func testable() throws -> Application {
    let app = Application(.testing)
    try configure(app)
    
    try app.autoRevert().wait()
    try app.autoMigrate().wait()

    return app
  }
}
