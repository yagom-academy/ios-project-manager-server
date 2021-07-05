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
        projectItems.group(":progress") { projectItem in
            projectItem.get(use: read)
        }
        let projectItem = routes.grouped("projectItem")
        projectItem.post(use: create)
        projectItem.patch(use: update)
        projectItem.delete(use: delete)
    }
    
    func read(req: Request) throws -> EventLoopFuture<[ProjectItem]> {
        let validProgress = ["todo", "doing", "done"]
        
        guard let progress = req.parameters.get("progress"), validProgress.contains(progress) else {
            throw HTTPError.invalidProgressInURL
        }
        
        return ProjectItem.query(on: req.db).filter(\.$progress == progress).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<ProjectItem> {
        guard req.headers.contentType == .json else {
            throw HTTPError.invalidContentType
        }
        
        do {
            try ProjectItem.Create.validate(content: req)
        } catch {
            throw HTTPError.validationFailedWhileCreating
        }
        
        let exist = try req.content.decode(ProjectItem.self)
        
        return exist.save(on: req.db).map { (result) -> ProjectItem in
            return exist
        }
    }
    
    func update(req: Request) throws -> EventLoopFuture<ProjectItem> {
        guard req.headers.contentType == .json else {
            throw HTTPError.invalidContentType
        }
        
        do {
            try ProjectItem.Update.validate(content: req)
        } catch {
            throw HTTPError.validationFailedWhileUpdating
        }
        
        let exist = try req.content.decode(ProjectItem.Update.self)
        
        return ProjectItem.find(exist.id, on: req.db)
            .unwrap(or: HTTPError.invalidID)
            .flatMap { item in
                if let title = exist.title {
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
            throw HTTPError.invalidContentType
        }
        
        let exist = try req.content.decode(ProjectItem.Delete.self)
        return ProjectItem.find(exist.id, on: req.db)
            .unwrap(or: HTTPError.invalidID)
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
