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
        guard request.headers.contentType == .json else {
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
        guard request.headers.contentType == .json else {
            throw TaskError.contentTypeIsNotJson
        }
        
        try TaskForPatch.validate(content: request)
        
        let updatedTask = try request.content.decode(TaskForPatch.self)
        
        if updatedTask.isAllNil {
            throw TaskError.allValuesAreNil
        }
        
        let result: EventLoopFuture<HTTPStatus> = Task.find(request.parameters.get("id"), on: request.db)
            .unwrap(or: Abort(.notFound)).flatMap {
                
                if let updatedTitle = updatedTask.title {
                    $0.title = updatedTitle
                }
                if let updatedCategory = updatedTask.category {
                    $0.category = updatedCategory
                }
                if let updatedContent = updatedTask.content {
                    $0.content = updatedContent
                }
                if let updatedDeadline = updatedTask.deadline_date {
                    $0.deadline_date = updatedDeadline
                }
                
                return $0.update(on: request.db).transform(to: .ok)
            }
        
        return result
    }
    
    func delete(request: Request) throws -> EventLoopFuture<HTTPStatus> {
        request.headers.contentType = .json

        guard request.headers.contentType == .json else {
            throw TaskError.contentTypeIsNotJson
        }
        
        let foundTask = Task.find(request.parameters.get("id"), on: request.db).unwrap(or: Abort(.notFound))
        let deleteProcess = deleteTask(oldvalue: foundTask, request: request)
        
        return fetchSuccessfulStatus(event: deleteProcess)
    }
    
    private func deleteTask<T: Task>(oldvalue: EventLoopFuture<T>, request: Request) -> EventLoopFuture<Void> {
        
        return oldvalue.flatMap {
            $0.delete(on: request.db)
        }
    }
    
    private func fetchSuccessfulStatus(event: EventLoopFuture<Void>) -> EventLoopFuture<HTTPStatus> {
        let status: EventLoopFuture<HTTPStatus> = event.transform(to: .ok)
        
        return status
    }
}
