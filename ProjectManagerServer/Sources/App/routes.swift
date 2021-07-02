import Vapor
import Fluent

func routes(_ app: Application) throws {
    app.get("projectItems") { request -> EventLoopFuture<[ProjectItem]> in
        return ProjectItem.query(on: request.db).all()
    }
    
    app.post("projectItem") { req -> EventLoopFuture<ProjectItem> in
        let exist = try req.content.decode(ProjectItem.self)
        return exist.create(on: req.db).map { (result) -> ProjectItem in
            return exist
        }
    }
    
    app.patch("projectItem") { req -> EventLoopFuture<ProjectItem> in
        let exist = try req.content.decode(ProjectItem.self)
        return ProjectItem.find(exist.id, on: req.db).map { (result) -> ProjectItem in
            return exist
        }
    }
}
