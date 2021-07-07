//
//  File.swift
//  
//
//  Created by 천수현 on 2021/07/03.
//

import Fluent
import FluentPostgresDriver

struct MemoMigration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        _ = database.enum("memo_type")
            .case("toDo")
            .case("doing")
            .case("done")
            .create()

        return database.enum("memo_type")
            .read()
            .flatMap { memoType in
                database.schema(Memo.schema)
                    .id()
                    .field("title", .string, .required)
                    .field("content", .string, .required)
                    .field("deadline", .datetime, .required)
                    .field("memo_type", memoType, .required)
                    .create()
        }
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Memo.schema).delete()
    }
}
