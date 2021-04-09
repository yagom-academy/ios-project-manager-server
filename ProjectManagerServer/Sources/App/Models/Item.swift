//
//  File.swift
//  
//
//  Created by sole on 2021/04/02.
//

import Fluent
import Vapor

final class Item: Model {
    static let schema = "items"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "status")
    var status: Int
    
    @OptionalField(key: "description")
    var description: String?
    
    @OptionalField(key: "deadline")
    var deadline: Int?
    
    init() { }
    
    init(id: UUID? = nil,
         title: String,
         status: Int,
         description: String? = nil,
         deadline: Int? = nil) {
        self.id = id
        self.title = title
        self.status = status
        self.description = description
        self.deadline = deadline
    }
}

extension Item: Content { }
