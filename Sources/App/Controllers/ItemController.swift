import Fluent
import Vapor

struct ItemController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let items = routes.grouped("items")
        items.get(use: index)
        items.post(use: create)
        items.group(":itemID") { item in
            items.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Item]> {
        return Item.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Item> {
        let item = try req.content.decode(Item.self)
        return item.save(on: req.db).map { item }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Item.find(req.parameters.get("itemID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
