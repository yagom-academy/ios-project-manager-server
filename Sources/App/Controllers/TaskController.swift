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
        tasks.group(":id") { task in
            task.patch(use: update)
            task.delete(use: delete)
        }
    }

    func showAll(req: Request) throws -> EventLoopFuture<[Task]> {
        return Task.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Response> {
        guard req.headers.contentType == .json else { throw TaskControllerError.contentTypeIsNotJSON }
        try Task.validate(content: req)
        let task = try req.content.decode(Task.self)
        let eventLoopFutureTask = task.create(on: req.db).map { () -> Task in
            return task
        }

        return eventLoopFutureTask.encodeResponse(status: .created, for: req)
    }

    func update(req: Request) throws -> EventLoopFuture<Task> {
        guard let id = req.parameters.get("id", as: Int.self) else { throw TaskControllerError.invalidID }
        guard req.headers.contentType == .json else { throw TaskControllerError.contentTypeIsNotJSON }
        try PatchTask.validate(content: req)
        let patchTask = try req.content.decode(PatchTask.self)
        guard !patchTask.isEmpty else { throw TaskControllerError.patchTaskIsEmpty }
        
        let eventLoopFutureTask: EventLoopFuture<Task> = Task.find(id, on: req.db)
            .unwrap(or: TaskControllerError.idNotFound)
            .flatMap { task in
                var isChanged: Bool = false

                if let title = patchTask.title,
                   task.title != title {
                    task.title = title
                    isChanged = true
                }

                if let deadline = patchTask.deadline,
                   task.deadline != deadline {
                    task.deadline = deadline
                    isChanged = true
                }

                if let state = patchTask.state,
                   task.state != state {
                    task.state = state
                    isChanged = true
                }

                if let contents = patchTask.contents,
                   task.contents != contents {
                    task.contents = contents
                    isChanged = true
                }

                guard isChanged else {
                    return Task.find(id, on: req.db)
                        .unwrap(or: TaskControllerError.idNotFound)
                }

                return task.update(on: req.db).transform(to: task)
            }

        return eventLoopFutureTask
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard let id = req.parameters.get("id", as: Int.self) else { throw TaskControllerError.invalidID }
        let eventLoopFutureHttpStatus = Task.find(id, on: req.db)
                                        .unwrap(or: TaskControllerError.idNotFound)
                                        .flatMap { $0.delete(on: req.db) }
                                        .transform(to: HTTPStatus.noContent)
        return eventLoopFutureHttpStatus
    }
}
