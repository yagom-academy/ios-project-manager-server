//
//  Task.swift
//  
//
//  Created by steven on 2021/06/30.
//

import Fluent
import Vapor

final class Task: Model, Content {
    static let schema = "tasks"

    @ID(custom: "id")
    var id: Int?

    @Field(key: "title")
    var title: String

    @Field(key: "deadline")
    var deadline: Date

    @Enum(key: "state")
    var state: State

    @OptionalField(key: "contents")
    var contents: String?

    @Timestamp(key: "last_modified_date", on: .update)
    var lastModifiedDate: Date?

    init() { }

    init(id: Int? = nil,
         title: String,
         deadline: Date,
         state: State,
         contents: String? = nil,
         lastModifiedDate: Date? = nil) {
        self.id = id
        self.title = title
        self.deadline = deadline
        self.state = state
        self.contents = contents
        self.lastModifiedDate = lastModifiedDate
    }
}

enum State: String, Codable {
    case todo, doing, done
}
