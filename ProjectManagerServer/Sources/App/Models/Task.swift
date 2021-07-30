//
//  File.swift
//  
//
//  Created by KangKyung, James on 2021/07/28.
//

import Fluent
import Vapor

final class Task: Model, Content {
    
    enum Category_type: String, Codable {
        case todo, doing, done
    }
    
    static let schema: String = "tasks"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "deadline_date")
    var deadline_date: Date
    
    @Enum(key: "category")
    var category: Category_type
    
    init() { }
    
    init(id: UUID?, title: String, content: String, deadline_date: Date, category: Category_type) {
        self.id = id
        self.title = title
        self.content = content
        self.deadline_date = deadline_date
        self.category = category
    }
}

extension Task: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("content", as: String?.self, required: false)
        validations.add("deadline_date", as: Date.self, is: .valid)
        validations.add("category", as: String.self, is: .in("todo", "doing", "done"))
    }
}
