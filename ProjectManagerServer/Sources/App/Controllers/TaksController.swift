//
//  File.swift
//  
//
//  Created by KangKyung, James on 2021/07/29.
//

import Fluent
import Vapor

struct TaskController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let task = routes.grouped("project")
        
        task.get("todo", use: readTodoTasks)
        task.get("doing", use: readDoingTasks)
        task.get("done", use: readDoneTasks)
        
        task.group("task") { task in
            task.post(use: create)
        }
        
        task.group("task", ":id") { task in
            task.patch(use: update)
            task.delete(use: delete)
        }
    }
    
    func create(request: Request) throws -> EventLoopFuture<Task> {
        let contentType = request.headers[ContentType.string]
        if contentType != [ContentType.jsonType] {
            throw TaskError.contentTypeIsNotJson
        }
        
        try Task.validate(content: request)
        
        let task = try request.content.decode(Task.self)
        return task.create(on: request.db).map { task }
    }
    
    func readTodoTasks(request: Request) throws -> EventLoopFuture<[Task]> {
        return Task.query(on: request.db).filter(\.$category == .todo).all()
    }
    
    func readDoingTasks(request: Request) throws -> EventLoopFuture<[Task]> {
        return Task.query(on: request.db).filter(\.$category == .doing).all()
    }
    
    func readDoneTasks(request: Request) throws -> EventLoopFuture<[Task]> {
        return Task.query(on: request.db).filter(\.$category == .done).all()
    }
    
    func update(request: Request) throws -> EventLoopFuture<HTTPStatus> {
        let contentType = request.headers[ContentType.string]
        if contentType != [ContentType.jsonType] {
            throw TaskError.contentTypeIsNotJson
        }
        
        try Task.validate(content: request)
        
        let task = try request.content.decode(Task.self)
        return Task.find(request.parameters.get("id"), on: request.db)
            .unwrap(or: Abort(.notFound)).flatMap {
                
                $0.title = task.title
                $0.category = task.category
                $0.content = task.content
                $0.deadline_date = task.deadline_date
                
                return $0.update(on: request.db).transform(to: .ok)
            }
    }
    
    func delete(request: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Task.find(request.parameters.get("id"), on: request.db)
            .unwrap(or: Abort(.badRequest))
            .flatMap{ $0.delete(on: request.db) }
            .transform(to: .ok)
    }
}
