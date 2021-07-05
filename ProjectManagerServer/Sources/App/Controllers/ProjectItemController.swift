//
//  ProjectItemController.swift
//  
//
//  Created by Wody, Kane, Ryan-Son on 2021/07/02.
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
        return ProjectItem.query(on: req.db).filter(\.$progress == progress).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<ProjectItem> {
        guard req.headers.contentType == .json else {
            throw Abort(.badRequest)
        }
        
        try ProjectItem.Create.validate(content: req)
        let exist = try req.content.decode(ProjectItem.self)
        
        return exist.save(on: req.db).map { (result) -> ProjectItem in
            return exist
        }
    }
    
    func update(req: Request) throws -> EventLoopFuture<ProjectItem> {
        guard req.headers.contentType == .json else {
            throw Abort(.badRequest)
        }
        
        try ProjectItem.Update.validate(content: req)
        let exist = try req.content.decode(ProjectItem.Update.self)
        
        return ProjectItem.find(exist.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { item in
                if let title = exist.title{
                    item.title = title
                }
                
                if let content = exist.content {
                    item.content = content
                }
                
                if let progress = exist.progress {
                    item.progress = progress
                }
                
                if let deadlineDate = exist.deadlineDate {
                    item.deadlineDate = deadlineDate
                }
                
                if let index = exist.index {
                    item.index = index
                }
                return item.update(on: req.db)
                    .map { return item }
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        guard req.headers.contentType == .json else {
            throw Abort(.badRequest)
        }
        
        let exist = try req.content.decode(ProjectItem.Delete.self)
        return ProjectItem.find(exist.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
