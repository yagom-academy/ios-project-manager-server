//
//  File.swift
//  
//
//  Created by 황인우 on 2021/07/28.
//

import Fluent
import FluentPostgresDriver

struct TaskMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let category = database.enum("category")
            .case("toDo")
            .case("doing")
            .case("done")
            .create()
        
        return database.enum("category").read().flatMap { category in
            database.schema(Task.schema)
                .id()
                .field("title", .string, .required)
                .field("content", .string, .required)
                .field("deadline_date", .date, .required)
                .create()
        }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Task.schema).delete()
    }
    
    
}
