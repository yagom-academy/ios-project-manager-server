import Fluent
import Vapor

struct TaskController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tasks = routes.grouped("tasks")
        tasks.get(use: showAll)
        tasks.post(use: create)
        tasks.group(":identifier") { tasks in
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
    
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Task.find(req.parameters.get("identifier"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.update(on: req.db) }
            .transform(to: .ok)
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Task.find(req.parameters.get("identifier"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
