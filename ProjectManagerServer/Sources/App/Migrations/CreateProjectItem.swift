//
//  CreateProjectItem.swift
//  
//
//  Created by Wody, Kane, Ryan-Son on 2021/07/02.
//

import Fluent

struct CreateProjectItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("projectItems")
            .id()
            .field("title", .string, .required)
            .field("content", .string, .required)
            .field("deadlineDate", .date, .required)
            .field("progress", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("projectItems").delete()
    }
}
