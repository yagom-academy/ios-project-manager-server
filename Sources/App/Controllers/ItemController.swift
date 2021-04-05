import Fluent
import Vapor

struct ItemController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let items = routes.grouped("items")
        items.get(use: readAll)
        
        let item = routes.grouped("item")
        item.post(use: create)
//        item.patch(":id", use: update)
        item.delete(":id", use: delete)
    }
    
    private func readAll(req: Request) throws -> EventLoopFuture<[ItemList]> {
        try checkContentType(req.headers.contentType)
        return Item.query(on: req.db).all().map { things -> [ItemList] in
            let group = Dictionary(grouping: things, by: { $0.state })
            var lists: [ItemList] = []
            for (key, value) in group {
                lists.append(ItemList(state: key, list: value))
            }
            return lists
        }
    }
    
    private func create(req: Request) throws -> EventLoopFuture<Item> {
        try checkContentType(req.headers.contentType)
        try Item.validate(content: req)
        let item = try req.content.decode(Item.self)
        return item.save(on: req.db).map { item }
    }
    
//    private func update(req: Request) throws -> EventLoopFuture<Item> {
//        try checkContentType(req.headers.contentType)
//        try Item.validate(content: req)
//        let item = try req.content.decode(Item.self)
//        return item.update(on: req.db).map { item }
//    }
//
    private func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try checkContentType(req.headers.contentType)
        let id = try checkID(req)
        return Item.find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    private func checkContentType(_ contentType: HTTPMediaType?) throws {
        guard let contentType = contentType, contentType == .json else {
            throw Abort(.unsupportedMediaType)
        }
    }
    
    private func checkID(_ req: Request) throws -> Int {
        guard let parameterID = req.parameters.get("id"), let id = Int(parameterID) else {
            throw Abort(.notFound)
        }
        return id
    }
}
