//
//  ProjectItem.swift
//  
//
//  Created by Wody, Kane, Ryan-Son on 2021/07/02.
//

import Fluent
import Vapor

final class ProjectItem: Model, Content {
    static let schema = "projectItems"
    
    struct Create: Content {
        let id: UUID?
        let title: String
        let content: String
        let deadlineDate: Date
        let progress: String
        let index: Int
    }
    
    struct Update: Content {
        let id: UUID
        let title: String?
        let content: String?
        let deadlineDate: Date?
        let progress: String?
        let index: Int?
    }
    
    struct Delete: Content {
        let id: UUID
    }
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "deadlineDate")
    var deadlineDate: Date
    
    @Field(key: "progress")
    var progress: String
    
    @Field(key: "index")
    var index: Int
    
    init() { }
    
    init(id: UUID? = nil, title: String, content: String, deadlineDate: Date, progress: String, index: Int) {
        self.id = id
        self.title = title
        self.content = content
        self.deadlineDate = deadlineDate
        self.progress = progress
        self.index = index
    }
}

extension ProjectItem.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, required: true)
        validations.add("content", as: String.self, is: .count(...1000), required: true)
        validations.add("progress", as: String.self, is: .in("todo", "doing", "done"), required: true)
        validations.add("index", as: Int.self, required: true)
        validations.add("deadlineDate", as: Date.self, required: true)
    }
}

extension ProjectItem.Update: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, required: false)
        validations.add("content", as: String.self, is: .count(...1000), required: false)
        validations.add("progress", as: String.self, is: .in("todo", "doing", "done"), required: false)
        validations.add("index", as: Int.self, required: false)
        validations.add("deadlineDate", as: Date.self, required: false)
    }
}
