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
        
        task.group(":category") { task in
            task.get(use: readCategorizedTasks)
        }
        
        task.group("task") { task in
            task.post(use: create)
        }
        
        task.group("task", ":id") { task in
            task.post(use: update)
            task.delete(use: delete)
        }
        
    }
    
    func create(request: Request) throws -> EventLoopFuture<Task> {
        let task = try request.content.decode(Task.self)
        return task.create(on: request.db).map { task }
    }
    
    func readCategorizedTasks(request: Request) throws -> EventLoopFuture<[Task]> {
        return Task.query(on: request.db).all()
    }
    
    func update(request: Request) throws -> EventLoopFuture<HTTPStatus> {
        let task = try request.content.decode(Task.self)
        return Task.find(request.parameters.get("id"), on: request.db).unwrap(or: Abort(.notFound)).flatMap {
            
            $0.title = task.title
            $0.category = task.category
            $0.content = task.content
            $0.deadline_date = task.deadline_date
            
            return $0.update(on: request.db).transform(to: .ok)
        }
    }
    
    func delete(request: Request) throws -> EventLoopFuture<Task> {
        return Task.find(request.parameters.get("id"), on: request.db).unwrap(or: Abort(.badRequest))
    }
}
