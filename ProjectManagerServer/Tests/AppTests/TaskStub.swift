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
    
    let expectedTitle = "James Good"
    let expectedContent = "king king"
    let expectedDate = Date()
    let expectedCategory = CategoryType.todo
}
