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
        memo.get("todo", use: getToDo)
        memo.get("doing", use: getDoing)
        memo.get("done", use: getDone)
        
        memo.post(use: create)
        memo.patch(use: update)
        memo.delete(use: delete)
    }
}

// MARK: - GET

extension MemoController {
    private enum SortOrder: String, Decodable {
        case ascending = "ascending"
        case descending = "descending"
    }
    
    private func getToDo(request: Request) throws -> EventLoopFuture<Page<Memo>> {
        return Memo.query(on: request.db)
            .filter(\.$memo_type == .todo)
            .sort(\.$due_date, sortOrder(request: request))
            .paginate(for: request)
    }
    
    private func getDoing(request: Request) throws -> EventLoopFuture<Page<Memo>> {
        return Memo.query(on: request.db)
            .filter(\.$memo_type == .doing)
            .sort(\.$due_date, sortOrder(request: request))
            .paginate(for: request)
    }
    
    private func getDone(request: Request) throws -> EventLoopFuture<Page<Memo>> {
        return Memo.query(on: request.db)
            .filter(\.$memo_type == .done)
            .sort(\.$due_date, sortOrder(request: request))
            .paginate(for: request)
    }
    
    private func sortOrder(request: Request) -> DatabaseQuery.Sort.Direction {
        if let sortOrder = request.query[SortOrder.self, at: "sort-order"] {
            if sortOrder == .descending {
                return .descending
            }
        }
        return .ascending
    }
}

// MARK: - POST

extension MemoController {
    private func create(request: Request) throws -> EventLoopFuture<Memo> {
        let contentType = request.headers["Content-Type"]

        if contentType != ["application/json"] {
            throw Abort(.custom(code: 400, reasonPhrase: "Content-Type should be application/json"))
        }

        try Memo.validate(content: request)
        let memo = try request.content.decode(Memo.self)
        return memo.create(on: request.db).map { memo }
    }
}

// MARK: - PATCH

extension MemoController {
    private func update(request: Request) throws -> EventLoopFuture<HTTPStatus> {
        let contentType = request.headers["Content-Type"]

        if contentType != ["application/json"] {
            throw Abort(.custom(code: 400, reasonPhrase: "Content-Type should be application/json"))
        }

        let patchMemo = try request.content.decode(PatchMemo.self)

        if let memoId = request.query[UUID.self, at: "memo-id"] {
            return Memo.find(memoId, on: request.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { memo in
                    if let title = patchMemo.title { memo.title = title }
                    if let content = patchMemo.content { memo.content = content }
                    if let due_date = patchMemo.due_date { memo.due_date = due_date }
                    if let memo_type = patchMemo.memo_type { memo.memo_type = memo_type }
                    return memo.update(on: request.db).transform(to: .ok)
                }
        } else {
            throw Abort(.custom(code: 404, reasonPhrase: "memo-id not found"))
        }
    }
}

// MARK: - DELETE

extension MemoController {
    private func delete(request: Request) throws -> EventLoopFuture<HTTPStatus> {
        if let memoId = request.query[UUID.self, at: "memo-id"] {
            return Memo.find(memoId, on: request.db)
                .unwrap(or: Abort(.notFound))
                .flatMap {
                    return $0.delete(on: request.db)
                }.transform(to: .ok)
        } else {
            throw Abort(.custom(code: 404, reasonPhrase: "memo-id not found"))
        }
    }
}
