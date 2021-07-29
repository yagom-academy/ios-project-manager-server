import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: UserController())
}

//    let tasks = app.grouped("tasks")
//
//    tasks.get(use: read)
//    tasks.post(use: create)
//    tasks.put(use: update)
//    tasks.delete(":taskId", use: delete)
//}
//
//func create(req: Request) throws -> EventLoopFuture<Task> {
//    let task = try req.content.decode(Task.self)
//    return task.create(on: req.db).map { task }
//}
//
//func read(req: Request) throws -> EventLoopFuture<[Task]> {
//    return Task.query(on: req.db).all()
//}
//
//func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//    let task = try req.content.decode(Task.self)
//
//    return Task.find(task.id, on: req.db)
//        .unwrap(or: Abort(.notFound))
//        .flatMap {
//            $0.title = task.title
//            $0.description = task.description
//            $0.dueDate = task.dueDate
//            $0.status = task.status
//            return $0.update(on: req.db).transform(to: .ok)
//        }
//}
//
//func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
//    return Task.find(req.parameters.get("taskId"), on: req.db)
//        .unwrap(or: Abort(.notFound))
//        .flatMap {
//            return $0.delete(on: req.db)
//        }.transform(to: .ok)
