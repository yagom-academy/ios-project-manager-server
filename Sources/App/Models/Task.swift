//
//  File.swift
//  
//
//  Created by 김찬우 on 2021/07/23.
//

import Vapor
import Fluent

final class Task: Model, Content {
    static let schema = "tasks"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "due_date")
    var due_date: Date
    
    @Enum(key: "status")
    var status: Status
    
    init() { }
    
    init(id: UUID? = nil,
         title: String,
         description: String,
         due_date: Date,
         status: Status) {
        self.id = id
        self.title = title
        self.description = description
        self.due_date = due_date
        self.status = status
    }
}

extension Task {
    enum Status: String, Codable {
        case todo
        case doing
        case done
    }
}
