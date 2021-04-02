//
//  File.swift
//  
//
//  Created by sole on 2021/04/02.
//

import Fluent

struct ItemMigration: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Item.schema)
                .id()
                .field("title", .string, .required)
                .field("status", .int, .required)
                .field("description", .string)
                .field("deadline", .int)
                .create()
        }
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Item.schema).delete()
    }
}
