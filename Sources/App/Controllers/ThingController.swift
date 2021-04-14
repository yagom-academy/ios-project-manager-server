import Vapor
import Fluent

struct ThingController: RouteCollection {
    let url: String
    
    func boot(routes: RoutesBuilder) throws {
        let things = routes.grouped("\(url)")
        things.get(use: showAll)
        things.post(use: create)
        things.group(":id") { things in
            things.delete(use: delete)
            things.patch(use: update)
        }
    }
    
    func showAll(req: Request) throws -> EventLoopFuture<[Thing]> {
        return Thing.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Thing> {
        try Thing.validate(content: req)
        let thing = try req.content.decode(Thing.self)
        return thing.create(on: req.db).map { thing }
    }
    
    func update(req: Request) throws -> EventLoopFuture<Thing> {
        let thingToUpdate = try req.content.decode(ThingToUpdate.self)
        return Thing.find(req.parameters.get("id"), on: req.db).unwrap(or: ThingError.notFoundID).map {
            if let title = thingToUpdate.title {
                $0.title = title
            }
            if let description = thingToUpdate.description {
                $0.description = description
            }
            if let state = thingToUpdate.state {
                $0.state = state
            }
            if let dueDate = thingToUpdate.dueDate {
                $0.dueDate = dueDate
            }
            $0.updatedAt = Date()
            $0.update(on: req.db)
            return Thing(id: $0.id, title: $0.title, description: $0.description, state: $0.state, dueDate: $0.dueDate, updatedAt: $0.updatedAt)
        }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Thing.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    private func isApplicationJSONAndUTF8(_ contentType: HTTPMediaType) -> Bool {
        if contentType.type == "application" && contentType.subType == "json" &&
            contentType.parameters["charset"] == "utf8" {
            return true
        }
        return false
    }
}
