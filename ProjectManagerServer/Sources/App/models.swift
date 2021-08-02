//
//  models.swift
//  
//
//  Created by 이성노 on 2021/07/28.
//

import Vapor
import Fluent

final class Task: Model, Content {

    static var schema: String = "tasks"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "body")
    var body: String
    
    @Timestamp(key: "due_date", on: .create)
    var due_date: Date?
    
    @Field(key: "state")
    var state: String
    
    @Field(key: "index_path")
    var index_path: Int
    
    init() { }
    
    init(id: UUID? = nil, title: String, body: String, due_date: Date? = nil, state: String, index_path: Int) {
        self.id = id
        self.title = title
        self.body = body
        self.due_date = due_date
        self.state = state
        self.index_path = index_path
    }
}

struct CreateTask: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tasks")
            .id()
            .field("title", .string, .required)
            .field("body", .string)
            .field("due_date", .datetime, .required)
            .field("state", .string, .required)
            .field("index_path", .int, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("tasks").delete()
    }
}
