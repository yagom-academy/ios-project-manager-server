//
//  File.swift
//  
//
//  Created by Ryan-Son on 2021/07/02.
//

import Fluent
import Vapor

struct ProjectItemController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let projectItems = routes.grouped("projectItems")
        projectItems.get(use: read)
        projectItems.post(use: create)
        projectItems.delete(use: delete)
    }
    
    func read(req: Request) throws -> EventLoopFuture<[ProjectItem]> {
        guard let progress = req.parameters.get("progress") else {
            throw Abort(.badRequest)
        }
        let item = ProjectItem.query(on: req.db).filter(\.$progress == progress).all()
        return item
    }
    
    func create(req: Request) throws -> EventLoopFuture<ProjectItem> {
        let exist = try req.content.decode(ProjectItem.self)
        return exist.save(on: req.db).map { (result) -> ProjectItem in
            return exist
        }
    }
    
    func update(req: Request) throws -> EventLoopFuture<ProjectItem> {
        let exist = try req.content.decode(ProjectItem.self)
        
        return ProjectItem.find(exist.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { item in
                item.title = exist.title
                item.content = exist.content
                item.progress = exist.progress
                item.deadlineDate = exist.deadlineDate
                return item.update(on: req.db)
                    .map { return item }
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let exist = try req.content.decode(ProjectItem.self)
        return ProjectItem.find(exist.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
