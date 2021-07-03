import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!@"
    }
    
    app.get("test") { req -> String in
        return "test, test!"
    }
    
    try app.register(collection: TaskController())
    try app.register(collection: HistoryController())
}
