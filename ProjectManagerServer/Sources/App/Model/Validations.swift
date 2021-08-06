//
//  File.swift
//  
//
//  Created by kio on 2021/08/05.
//

import Vapor


extension PatchTask: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("id", as: UUID.self, required: true )
        validations.add("title", as: String.self, required: false)
        validations.add("description", as: String.self, required: false)
        validations.add("deadline", as: Int.self, required: false)
        validations.add("status", as: String.self, is: .in("todo", "doing", "done"), required: false)
    }
}

extension PostTask: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, required: true)
        validations.add("description", as: String.self, is: .count(...1000), required: false)
        validations.add("deadline", as: Int.self, required: true )
        validations.add("status", as: String.self, is: .in("todo", "doing", "done"), required: true)
    }
}

extension DeleteTask: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("id", as: UUID.self, required: true )
    }
}
