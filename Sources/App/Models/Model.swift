//
//  File.swift
//  
//
//  Created by YB on 2021/07/27.
//

import Vapor
import Fluent

final class Model: Model, Content {
    static let schema = "tasks"

    @Field(key: "tasks")
    var tasks: [Task]

    init() { }

    init(tasks: [Task]) {
        self.tasks = tasks
    }
}
