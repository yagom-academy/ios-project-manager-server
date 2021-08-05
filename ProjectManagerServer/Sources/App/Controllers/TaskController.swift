//
//  File.swift
//  
//
//  Created by TORI on 2021/08/04.
//

import Fluent
import Vapor

struct TaskController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
            let projectItems = routes.grouped("tasks")
            projectItems.group(":status") { projectItem in
                projectItem.get(use: read)
            }
        
            let projectItem = routes.grouped("task")
            projectItem.post(use: create)
            projectItem.patch(use: update)
            projectItem.delete(use: delete)
    }

    func create(req: Request) throws -> EventLoopFuture<Task> {
        guard req.headers.contentType == .json else {
            throw HTTPError.invalidContentType
        }
        
        do {
            try PostTask.validate(content: req)
        } catch {
            throw HTTPError.failedToCreatingValidation
        }
        
        let exist = try req.content.decode(PostTask.self)
        let newProjectItem = Task(projectItem: exist)
        return newProjectItem.create(on: req.db).map { newProjectItem }
    }
    
    func read(req: Request) throws -> EventLoopFuture<[Task]> {
        let validStatus = ["todo", "doing", "done"]

        guard let status = req.parameters.get("status"), validStatus.contains(status) else {
            throw Abort(.badRequest)
        }
        return Task.query(on: req.db).filter(\.$status == status).all()
    }
    
    func update(req: Request) throws -> EventLoopFuture<Task> {
        guard req.headers.contentType == .json else {
            throw HTTPError.invalidContentType
        }
        
        do {
            try PatchTask.validate(content: req)
        } catch {
            throw HTTPError.failedToUpdatingValidation
        }
        
        let exist = try req.content.decode(PatchTask.self)

        return Task.find(exist.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { item in
                if let title = exist.title { item.title = title }
                if let description = exist.description { item.description = description }
                if let status = exist.status { item.status = status }
                if let deadline = exist.deadline { item.deadline = deadline }
                
                return item.update(on: req.db).map { return item }
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard req.headers.contentType == .json else {
            throw HTTPError.invalidContentType
        }
        
        let exist = try req.content.decode(DeleteTask.self)
        return Task.find(exist.id, on: req.db)
            .unwrap(or: HTTPError.invalidID)
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
