//
//  File.swift
//  
//
//  Created by 황인우 on 2021/07/28.
//

import Fluent
import Vapor

final class Task: Model, Content {
    
    enum Category_type: String, Codable {
        case toDo, doing, done
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
