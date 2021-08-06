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
    
    let expectedId = UUID(uuidString: "B60AC9A4-9D6B-489F-9373-F9A2412B818E")
    let expectedTitle = "James Good"
    let expectedContent = "king king"
    let expectedDate = Date()
    let expectedCategory = CategoryType.todo
}
