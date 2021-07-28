import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "안녕하세요"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
