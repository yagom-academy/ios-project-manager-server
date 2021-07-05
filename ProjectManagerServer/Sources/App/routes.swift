import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get("tasks") { req -> EventLoopFuture<[Task]> in
        return Task.query(on: req.db).all()
    }
    
    app.post("tasks") { req -> EventLoopFuture<Task> in
        
        let task = try req.content.decode(Task.self)
        return task.create(on: req.db).map { task }
    }
    
    app.get("histories") { req -> EventLoopFuture<[History]> in
        return History.query(on: req.db).all()
    }
    
    app.post("histories") { req -> EventLoopFuture<History> in
        
        let history = try req.content.decode(History.self)
        return history.create(on: req.db).map { history }
    }
}
