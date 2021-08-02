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

enum Status: String, Codable {
    case todo
    case doing
    case done
}

extension Task: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("description", as: String.self, is: .count(...1000), required: true)
        validations.add("dueDate", as: Double.self, is: .valid)
        validations.add("status", as: String.self, is: .in("todo", "doing", "done"))
    }
}
