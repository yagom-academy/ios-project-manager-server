//
//  File.swift
//  
//
//  Created by 천수현 on 2021/07/06.
//

import Fluent
import Vapor

struct MemoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let memo = routes.grouped("memo")
        memo.get { req in
            return "memo페이지"
        }
        memo.post(use: create)
    }
    
    func create(request: Request) throws -> EventLoopFuture<Memo> {
        let memo = try request.content.decode(Memo.self)
        return memo.create(on: request.db).map { memo }
    }
}
