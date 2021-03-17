//
//  NewThing.swift
//  
//
//  Created by 김지혜 on 2021/03/11.
//

import FluentPostgresDriver
import Vapor

final class NewThing: Model {
    static let schema = "things"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String?
    
    @Field(key: "due_date")
    var dueDate: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: Int? = nil, title: String, description: String? = nil, dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
    }
}
