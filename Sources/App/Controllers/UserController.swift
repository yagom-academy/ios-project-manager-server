//
//  File.swift
//  
//
//  Created by YB on 2021/07/29.
//

import Foundation
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tasks = routes.grouped("tasks")

        routes.get {_ in
            return "It works!!!!!!"
        }

        tasks.get(use: read)
        tasks.post(use: create)
        tasks.put(":taskId", use: update)
        tasks.delete(":taskId", use: delete)
    }
}

extension UserController {
    func read(req: Request) throws -> EventLoopFuture<[Task]> {
        return Task.query(on: req.db).all()
    }
}

extension UserController {
    func create(req: Request) throws -> EventLoopFuture<Task> {
        guard req.headers.contentType == .json else {
            throw HTTPError.isValidContentType
        }

        try Task.validate(content: req)
        let task = try req.content.decode(Task.self)

        return task.create(on: req.db).map { task }
    }
}

extension UserController {
    func update(req: Request) throws -> EventLoopFuture<Task> {
        guard req.headers.contentType == .json else {
            throw HTTPError.isValidContentType
        }

        try Task.validate(content: req)
        let taskForPut = try req.content.decode(TaskForPut.self)

        return Task.find(req.parameters.get("taskId"), on: req.db)
            .unwrap(or: HTTPError.notExistID)
            .flatMap {
                $0.title = taskForPut.title
                $0.description = taskForPut.description
                $0.dueDate = taskForPut.dueDate
                $0.status = taskForPut.status
                return $0.update(on: req.db)
            }.flatMap {
                Task.find(req.parameters.get("taskId"), on: req.db)
            }.unwrap(or: HTTPError.notExistID)
    }
}

extension UserController {
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Task.find(req.parameters.get("taskId"), on: req.db)
            .unwrap(or: HTTPError.notExistID)
            .flatMap {
                return $0.delete(on: req.db)
            }.transform(to: .ok)
    }
}
