import Fluent
import Vapor

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
        guard let contentType = req.headers.contentType, contentType == .json else {
            throw TaskError.invalidContentType
        }
        try Task.validate(content: req)
        let task = try req.content.decode(Task.self)
        return task.create(on: req.db).map { task }
    }
    
    func update(req: Request) throws-> EventLoopFuture<Task> {
        guard let contentType = req.headers.contentType, contentType == .json else {
            throw TaskError.invalidContentType
        }
        try Task.validate(content: req)
        let requestedTask = try req.content.decode(Task.self)
        return Task.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { task in
                task.title = requestedTask.title
                task.description = requestedTask.description
                task.date = requestedTask.date
                task.status = requestedTask.status
                return task.save(on: req.db).map{ task }
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        return Task.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
