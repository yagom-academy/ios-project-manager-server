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
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String?
    
    @Field(key: "deadline")
    var deadline: Date?
    
    @Field(key: "status")
    var status: Int
    
    @Field(key: "status_index")
    var status_index: Int

    init() { }

    init(id: UUID? = nil, title: String, description: String? = nil, deadline: Date? = nil, status: Int, status_index: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.deadline = deadline
        self.status = status
        self.status_index = status_index
    }
}
