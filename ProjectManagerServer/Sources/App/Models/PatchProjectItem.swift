//
//  PatchProjectItem.swift
//  
//
//  Created by Ryan-Son on 2021/07/08.
//

import Vapor

struct PatchProjectItem: Content {
    let id: UUID
    let title: String?
    let content: String?
    let deadlineDate: Date?
    let progress: String?
    let index: Int?
}

extension PatchProjectItem: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("id", as: String.self, required: true)
        validations.add("title", as: String.self, required: false)
        validations.add("content", as: String.self, is: .count(...1000), required: false)
        validations.add("progress", as: String.self, is: .in("todo", "doing", "done"), required: false)
        validations.add("index", as: Int.self, required: false)
        validations.add("deadlineDate", as: Date.self, required: false)
    }
}
