//
//  File.swift
//  
//
//  Created by kio on 2021/07/23.
//

import Fluent

struct CreateProjectItem: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        
        return  database.schema(Task.schema)
            .id()
            .field("title", .string, .required)
            .field("description", .string)
            .field("deadline", .int, .required)
            .field("status", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Task.schema).delete()
    }
}
