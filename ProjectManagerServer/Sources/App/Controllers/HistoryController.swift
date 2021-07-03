import Fluent
import Vapor

struct HistoryController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let history = routes.grouped("histories")
        history.get(use: showAll)
        history.put(use: update)
    }

    func showAll(req: Request) throws -> EventLoopFuture<[History]> {
        return History.query(on: req.db).all()
    }
    
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return History.query(on: req.db).update()
            .transform(to: .ok)
    }
}
