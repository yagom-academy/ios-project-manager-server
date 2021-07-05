//
//  TaskMigration.swift
//  
//
//  Created by steven on 2021/06/30.
//

import Fluent

struct TaskMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("state")
            .case("todo")
            .case("doing")
            .case("done")
            .create()

        return database.enum("state").read().flatMap { state in
            database.schema(Task.schema)
                .field("id", .int, .identifier(auto: true))
                .field("title", .string, .required)
                .field("deadline", .datetime, .required)
                .field("state", state, .required)
                .field("contents", .string)
                .field("last_modified_date", .datetime, .required)
                .create()
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Task.schema).delete()
    }
}
