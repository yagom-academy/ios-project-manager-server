//
//  File.swift
//  
//
//  Created by KangKyung, James on 2021/07/28.
//

import Fluent
import FluentPostgresDriver

struct TaskMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("category")
            .case("todo")
            .case("doing")
            .case("done")
            .create()
        
        return database.enum("category").read().flatMap { category in
            database.schema(Task.schema)
                .id()
                .field("title", .string, .required)
                .field("content", .string)
                .field("deadline_date", .datetime, .required)
                .field("category", category, .required)
                .create()
        }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Task.schema).delete()
    }
}
