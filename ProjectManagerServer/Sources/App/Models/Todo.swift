//
//  Todo.swift
//  
//
//  Created by Yeon on 2021/03/18.
//

import Fluent
import Vapor

final class Todo: Model, Content {
    static let schema = "todos"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String?
    
    @Field(key: "deadline")
    var deadline: Date?
    
    @Field(key: "status")
    var status: Int

    init() { }

    init(id: Int? = nil, title: String, description: String? = nil, deadline: Date? = nil, status: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.deadline = deadline
        self.status = status
    }
}
