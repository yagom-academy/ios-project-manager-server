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
        memo.get("todo", ":pageId", use: getToDo)
        memo.get("doing", ":pageId", use: getDoing)
        memo.get("done", ":pageId", use: getDone)
        
        memo.post(use: create)
        memo.patch(":memoId", use: update)
        memo.delete(":memoId", use: delete)
    }
    
    
    func getToDo(request: Request) throws -> EventLoopFuture<[Memo]> {
        return Memo.query(on: request.db)
            .filter(\.$memo_type == .toDo)
            .all()
    }
    
    func getDoing(request: Request) throws -> EventLoopFuture<[Memo]> {
        return Memo.query(on: request.db)
            .filter(\.$memo_type == .doing)
            .all()
    }
    
    func getDone(request: Request) throws -> EventLoopFuture<[Memo]> {
        return Memo.query(on: request.db)
            .filter(\.$memo_type == .done)
            .all()
    }
    
    func create(request: Request) throws -> EventLoopFuture<Memo> {
        let memo = try request.content.decode(Memo.self)
        return memo.create(on: request.db).map { memo }
    }
    
    func update(request: Request) throws -> EventLoopFuture<HTTPStatus> {
        let memo = try request.content.decode(Memo.self)
        return Memo.find(request.parameters.get("memoId"), on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.title = memo.title
                $0.content = memo.content
                $0.due_date = memo.due_date
                return $0.update(on: request.db).transform(to: .ok)
            }
    }
    
    func delete(request: Request) throws -> EventLoopFuture<HTTPStatus> {

        return Memo.find(request.parameters.get("memoId"), on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                return $0.delete(on: request.db) // 여기에 transform 적었더니 오류
            }.transform(to: .ok)
    }
}
