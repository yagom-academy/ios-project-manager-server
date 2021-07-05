//
//  TaskController.swift
//  
//
//  Created by steven on 2021/07/05.
//

import Vapor
import Fluent

struct TaskController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tasks = routes.grouped("tasks")
        tasks.get(use: showAll)
        tasks.post(use: create)
        tasks.group(":id") { tasks in
            tasks.patch(use: update)
            tasks.delete(use: delete)
        }
    }
    
    func showAll(req: Request) throws -> EventLoopFuture<[Task]> {
        return Task.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Task> {
        let task = try req.content.decode(Task.self)
        return task.create(on: req.db).map { task }
    }
    
    func update(req: Request) throws -> EventLoopFuture<Task> {
        let patchTask = try req.content.decode(PatchTask.self)
        return Task.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { task in
                if let title = patchTask.title {
                    task.title = title
                }
                
                if let deadline = patchTask.deadline {
                    task.deadline = deadline
                }
                
                if let state = patchTask.state {
                    task.state = state
                }
                
                if let contents = patchTask.contents {
                    task.contents = contents
                }
                
                return task.update(on: req.db).transform(to: task)
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Task.find(req.parameters.get("id"), on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { $0.delete(on: req.db) }
                    .transform(to: .noContent)
    }
}
