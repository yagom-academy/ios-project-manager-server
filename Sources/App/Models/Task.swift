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
    
    @Field(key: "dueDate")
    var dueDate: Double
    
    @Enum(key: "status")
    var status: Status
    
    init() { }
    
    init(id: UUID? = nil,
         title: String,
         description: String,
         dueDate: Double,
         status: Status) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.status = status
    }
}

extension Task {
    enum Status: String, Codable {
        case TODO
        case DOING
        case DONE
    }
}
