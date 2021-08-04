//
//  File.swift
//  
//
//  Created by kio on 2021/07/29.
//

import Fluent
import Vapor

final class Task: Model, Content {
    static let schema = "tasks"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @OptionalField(key: "description")
    var description: String?
    
    @Field(key: "deadline")
    var deadline: Int
    
    @Field(key: "status")
    var status: String

    init() { }
    
    init(id: UUID? = nil,
         title: String,
         description: String? = nil,
         deadline: Int,
         status: String) {
        self.id = id
        self.title = title
        self.description = description
        self.deadline = deadline
        self.status = status
    }
    
    init(projectItem: PostTask) {
        self.id = projectItem.id
        self.title = projectItem.title
        self.description = projectItem.description
        self.deadline = projectItem.deadline
        self.status = projectItem.status
    }
}

