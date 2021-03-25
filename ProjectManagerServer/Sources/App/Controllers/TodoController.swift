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
    
    func readAll(req: Request) throws -> EventLoopFuture<[TodoList]> {
        try checkContentType(req)
        
        return Todo.query(on: req.db).all().map { todo -> [TodoList] in
            var todoList: [TodoList] = []
            let oneTodo = todo.compactMap { $0.response }
            todoList.append(TodoList(todoList: oneTodo))
            
            return todoList
        }
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
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
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
            throw TodoError.invalidID
        }
        return id
    }
}

