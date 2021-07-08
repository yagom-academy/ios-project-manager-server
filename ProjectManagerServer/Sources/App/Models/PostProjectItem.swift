//
//  PostProjectItem.swift
//  
//
//  Created by Ryan-Son on 2021/07/08.
//

import Vapor

struct PostProjectItem: Content {
    let id: UUID?
    let title: String
    let content: String
    let deadlineDate: Date
    let progress: ProjectItem.Progress
    let index: Int
}

extension PostProjectItem: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, required: true)
        validations.add("content", as: String.self, is: .count(...1000), required: true)
        validations.add("progress", as: String.self, is: .in("todo", "doing", "done"), required: true)
        validations.add("index", as: Int.self, required: true)
        validations.add("deadlineDate", as: Date.self, required: true)
    }
}
