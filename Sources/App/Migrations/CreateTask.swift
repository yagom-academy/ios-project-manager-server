//
//  File.swift
//  
//
//  Created by 김찬우 on 2021/07/23.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreatTask: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
             _ = database.enum("task_type")
                 .case("todo")
                 .case("doing")
                 .case("done")
                 .create()

             return database.enum("task_type")
                 .read()
                 .flatMap { memoType in
                     database.schema(Task.schema)
                         .id()
                         .field("title", .string, .required)
                         .field("description", .string, .required)
                         .field("due_date", .datetime, .required)
                         .field("status", memoType, .required)
                         .create()
             }
         }

         func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema(Task.schema).delete()
         }
}
