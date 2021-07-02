import Vapor
import Fluent

func routes(_ app: Application) throws {
    let projectItemController = ProjectItemController()
    app.get("projectItems", ":progress", use: projectItemController.read(req:))
    app.post("projectItem", use: projectItemController.create(req:))
    app.patch("projectItem", use: projectItemController.update(req:))
    app.delete("projectItem", use: projectItemController.delete(req:))
}




//app.get("projectItems", ":progress") { req -> EventLoopFuture<[ProjectItem]> in
//    guard let progress = req.parameters.get("progress") else {
//        throw Abort(.badRequest)
//    }
//    let item = ProjectItem.query(on: req.db).filter(\.$progress == progress).all()
//    return item
//}
//
//app.post("projectItem") { req -> EventLoopFuture<ProjectItem> in
//    let exist = try req.content.decode(ProjectItem.self)
//    return exist.create(on: req.db).map { (result) -> ProjectItem in
//        return exist
//    }
//}
//
//app.patch("projectItem") { req -> EventLoopFuture<ProjectItem> in
//    let exist = try req.content.decode(ProjectItem.self)
//    return ProjectItem.find(exist.id, on: req.db).map { (result) -> ProjectItem in
//        return exist
//    }
//}
//
//app.delete("projectItem") { req -> EventLoopFuture<ProjectItem> in
//    let exist = try req.content.decode(ProjectItem.self)
//
////        let itemToDelete = ProjectItem.find(exist.id, on: req.db).flatMap { item in
////
////            guard let item = item else {
////                throw Abort(.notFound)
////            }
////
////            return item.dele
////        }
//    return ProjectItem
//}
