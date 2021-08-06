//
//  TaskStub.swift
//  
//
//  Created by KangKyung, James on 2021/08/05.
//

@testable import App
import XCTVapor

final class TaskStub {
    static let shared = TaskStub()
    
    let expectedID = UUID.init(uuidString: "641cc15f-f280-4a22-8b81-9186ea67ada6")
    let expectedTitle = "James Good"
    let expectedContent = "king king"
    let expectedDate = Date()
    let expectedCategory = CategoryType.todo
}
