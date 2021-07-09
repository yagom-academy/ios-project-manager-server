//
//  CreateProjectItem.swift
//  
//
//  Created by Wody, Kane, Ryan-Son on 2021/07/02.
//

import Fluent

struct CreateProjectItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("progress")
          .case("todo")
          .case("doing")
          .case("done")
          .create()
        return database.enum("progress").read().flatMap { progress in
            database.schema("projectItems")
                .id()
                .field("title", .string, .required)
                .field("content", .string, .required)
                .field("deadlineDate", .datetime, .required)
                .field("progress", progress, .required)
                .field("index", .int, .required)
                .create()
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("projectItems").delete()
    }
}
