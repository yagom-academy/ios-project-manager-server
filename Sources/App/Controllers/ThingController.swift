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
        }
    }
    
    func showAll(req: Request) throws -> EventLoopFuture<[Thing]> {
        return Thing.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Thing> {
        do {
            try Thing.validate(content: req)
        } catch {
            
        }
        let thing = try req.content.decode(Thing.self)
        return thing.create(on: req.db).map { thing }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Thing.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
