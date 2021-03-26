//
//  TodoController.swift
//  
//
//  Created by Yeon on 2021/03/18.
//

import Fluent
import Vapor

struct TodoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let todos = routes.grouped("todos")
        todos.get(use: readAll)
        
        let todo = routes.grouped("todo")
        todo.post(use: create)
        todo.group(":id") { todo in
            todo.patch(use: update)
            todo.get(use: read)
            todo.delete(use: delete)
        }
    }
    
    func readAll(req: Request) throws -> EventLoopFuture<[Todo]> {
        try checkContentType(req)
        
        return Todo.query(on: req.db).all()
    }
    
    func read(req: Request) throws -> EventLoopFuture<Todo> {
        try checkContentType(req)
        let id = try checkID(req)
        
        return Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func create(req: Request) throws -> EventLoopFuture<Response> {
        try checkContentType(req)
        let todoCreate = try req.content.decode(TodoCreate.self)
        let todo = Todo(title: todoCreate.title,
                        description: todoCreate.description,
                        deadline: todoCreate.deadline,
                        status: todoCreate.status)
        
        return todo.save(on: req.db).flatMapThrowing {
            let header = ("Content-Type", "application/json; charset=utf-8")
            let bodyJsonData = try encodeHTTPBody(todo)
            
            return Response(status: .created,
                            headers: HTTPHeaders(dictionaryLiteral: header),
                            body: .init(data: bodyJsonData))
        }
    }
    
    func update(req: Request) throws -> EventLoopFuture<Response> {
        try checkContentType(req)
        let id = try checkID(req)
        let todoUpdate = try req.content.decode(TodoUpdate.self)
        
        guard todoUpdate.id == id else {
            throw TodoError.notMatchID
        }
        
        return Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { todo in
                if let title = todoUpdate.title {
                    todo.title = title
                }
                
                if let description = todoUpdate.description {
                    todo.description = description
                }
                
                if let status = todoUpdate.status {
                    todo.status = status
                }
                
                if let deadline = todoUpdate.deadline {
                    todo.deadline = deadline
                }
                todo.save(on: req.db)
                
                let header = ("Content-Type", "application/json; charset=utf-8")
                let bodyJsonData = try encodeHTTPBody(todo)
                
                return Response(status: .ok,
                                headers: HTTPHeaders(dictionaryLiteral: header),
                                body: .init(data: bodyJsonData))
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<Response> {
        try checkContentType(req)
        let id = try checkID(req)
        
        return Todo.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { todo in
                let header = ("Content-Type", "application/json; charset=utf-8")
                let bodyJsonData = try encodeHTTPBody(todo)
                todo.delete(on: req.db)
                
                return Response(status: .ok,
                                headers: HTTPHeaders(dictionaryLiteral: header),
                                body: .init(data: bodyJsonData))
            }
    }
    
    private func encodeHTTPBody(_ body: Todo) throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let bodyJsonData = try encoder.encode(body)
        
        return bodyJsonData
    }
    
    private func checkContentType(_ req: Request) throws {
        guard let contentType = req.headers.contentType,
              contentType == .json else {
            throw Abort(.unsupportedMediaType)
        }
    }
    
    private func checkID(_ req: Request) throws -> Int {
        guard let deliveredID = req.parameters.get("id"),
              let id = Int(deliveredID) else {
            throw TodoError.invalidIDType
        }
        return id
    }
}

