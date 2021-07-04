//
//  File.swift
//  
//
//  Created by 최정민 on 2021/07/04.
//

import Fluent

struct HistoryMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("status")
            .case("toDo")
            .case("doing")
            .case("done")
            .create()
        
        _ = database.enum("action")
            .case("Moved")
            .case("Updated")
            .case("Added")
            .case("Removed")
            .create()
        
        return database.enum("status").read().flatMap { status in
            database.enum("action").read().flatMap { action in
                database.schema("histories")
                    .id()
                    .field("action", action)
                    .field("previous_status", status)
                    .field("changed_status", status)
                    .field("updated_title", .string)
                    .field("task_id", .string)
                    .create()
            }
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("histories").delete()
    }
}
