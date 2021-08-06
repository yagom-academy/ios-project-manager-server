//
//  File.swift
//  
//
//  Created by KangKyung, James on 2021/08/05.
//

import Fluent
import Vapor

struct TaskForPatch: Content {
    
    var title: String?
    var content: String?
    var deadline_date: Date?
    var category: Category_type?
    
    
    var isAllNil: Bool {
        let allNilIsTrue = title == nil && content == nil && deadline_date == nil && category == nil
        return allNilIsTrue
    }
}

extension TaskForPatch: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, required: false)
        validations.add("content", as: String.self, required: false)
        validations.add("deadline_date", as: Date.self, required: false)
        validations.add("category", as: String.self, required: false)
    }
}
