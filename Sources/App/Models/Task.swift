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

enum State: String, Codable, CaseIterable {
    case todo, doing, done

    static var description: [String] {
        return Self.allCases.map { $0.rawValue }
    }
}

extension Task: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("id", as: Int?.self, is: .nil, required: false)
        validations.add("title", as: String.self, is: .count(1...50), required: true)
        validations.add("state", as: String.self, is: .in(State.description), required: true)
        validations.add("deadline", as: Double.self, is: .range(0...253402182000), required: true)
        validations.add("contents", as: String?.self, is: .nil || .count(1...1000), required: false)
        validations.add("last_modified_date", as: Double?.self, is: .nil, required: false)
    }
}
