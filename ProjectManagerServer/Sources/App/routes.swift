import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.post("test") { req -> EventLoopFuture<Todo> in
        let exist = try req.content.decode(Todo.self)
        
        return exist.create(on: req.db).map { (result) -> Todo in
            return exist
        }
    }

    app.get("testAll") { req -> EventLoopFuture<[Todo]> in
        return Todo.query(on: req.db).all()
    }
    
    try app.register(collection: TodoController())
}
