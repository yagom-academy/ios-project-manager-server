//
//  File.swift
//  
//
//  Created by kio on 2021/07/23.
//

import Fluent

struct CreateProjectItem: Migration {
    /// 데이터베이스에 변경을 만드는 메서드
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("projectItems")
            .id()
            .field("title", .string, .required)
            .field("description", .string, .required)
            .field("deadline", .double, .required)
            .field("status", .string, .required)
            .create()
    }

    /// 가능한 경우 `prepare`에서 만든 변경사항을 되돌리는(undo) 메서드, 현재는 스키마 삭제로 설정됨
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("projectItems").delete()
    }
}
