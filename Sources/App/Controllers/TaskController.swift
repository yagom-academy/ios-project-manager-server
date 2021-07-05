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
    }
    
    func showAll(req: Request) throws -> EventLoopFuture<[Task]> {
        return Task.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Task> {
        let task = try req.content.decode(Task.self)
        return task.create(on: req.db).map { task }
    }
}
