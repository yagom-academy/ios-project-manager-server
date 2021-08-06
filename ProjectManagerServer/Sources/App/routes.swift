import Vapor
/*
- routes files is responsible for creating or managing all the different routes. Meaning when you go to to local horseflesh.
- later on, you will learn that it will be much better idea to separate out all the routes into a controller file.
 */
func routes(_ app: Application) throws {
    
    try app.register(collection: TaskController())
    
    // localhost:8080/
    app.get { req in
        return "It works!"
    }

    // localhost:8080/hello
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
