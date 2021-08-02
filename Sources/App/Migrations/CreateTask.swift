//
//  File.swift
//  
//
//  Created by 김찬우 on 2021/07/23.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateTask: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
             _ = database.enum("status")
                 .case("todo")
                 .case("doing")
                 .case("done")
                 .create()

         return database.enum("status")
             .read()
             .flatMap { status in
                 database.schema(Task.schema)
                     .id()
                     .field("title", .string, .required)
                     .field("description", .string, .required)
                     .field("dueDate", .double, .required)
                     .field("status", status, .required)
                     .create()
         }
     }

     func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Task.schema).delete()
     }
}
