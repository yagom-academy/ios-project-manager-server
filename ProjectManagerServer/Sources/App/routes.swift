import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "Index page"
    }

    app.get("hello") { req -> String in
        return "Hello, world! babian"
    }
}
