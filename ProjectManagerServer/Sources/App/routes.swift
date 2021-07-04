import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world$"
    }
    
    app.get("tasks") { req -> EventLoopFuture<[Task]> in
        return Task.query(on: req.db).all()
    }//@
    
    app.post("tasks") { req -> EventLoopFuture<Task> in
        
        let task = try req.content.decode(Task.self)
        return task.create(on: req.db).map { task }
    }
}
