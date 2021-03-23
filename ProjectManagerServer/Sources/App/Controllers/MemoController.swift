import Fluent
import Vapor

struct MemoController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let memos = routes.grouped("memos")
        memos.get(use: readAllMemo)
        
        let memo = routes.grouped("memo")
        memo.post(use: createMemo)
        memo.patch(":index", use: updateMemo)
        memo.delete(":index", use: deleteMemo)
    }
    
    private func readAllMemo(request: Request) throws -> EventLoopFuture<[Memo]> {
        return Memo.query(on: request.db).all()
    }
    
    private func createMemo(request: Request) throws -> EventLoopFuture<Memo> {
        try checkValidContentType(request.headers.contentType)
        let memo = try request.content.decode(Memo.self)
        return memo.save(on: request.db).map {
            memo
        }
    }
    
    private func updateMemo(request: Request) throws -> EventLoopFuture<Memo> {
        try checkValidContentType(request.headers.contentType)
        
        guard let index = UUID(uuidString: request.parameters.get("index")!) else {
            throw Abort(.badRequest)
        }
        
        _ = Memo.query(on: request.db)
            .filter(\.$id == index)
            .first()
            .unwrap(orError: Abort(.noContent))
        
        let requestMemo = try request.content.decode(PatchMemo.self)

        if let title = requestMemo.title {
            _ = Memo.query(on: request.db)
                .set(\.$title, to: title)
                .filter(\.$id == index)
                .update()
        }
        
        if let description = requestMemo.description {
            _ = Memo.query(on: request.db)
                .set(\.$description, to: description)
                .filter(\.$id == index)
                .update()
        }
        
        if let date = requestMemo.date {
            _ = Memo.query(on: request.db)
                .set(\.$date, to: date)
                .filter(\.$id == index)
                .update()
        }
        
        if let status = requestMemo.status {
            _ = Memo.query(on: request.db)
                .set(\.$status, to: status)
                .filter(\.$id == index)
                .update()
        }
        
        return Memo.query(on: request.db)
            .filter(\.$id == index)
            .first()
            .unwrap(or: Abort(.internalServerError))
    }
    
    private func deleteMemo(request: Request) throws -> EventLoopFuture<Memo> {
        let memo = Memo.find(request.parameters.get("index"), on: request.db)
            .unwrap(or: Abort(.notFound))
        
        _ = Memo.find(request.parameters.get("index"), on: request.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.delete(on: request.db)
            }
        
        return memo
    }
    
    private func checkValidContentType(_ contentType: HTTPMediaType?) throws {
        guard let contentType = contentType else {
            throw Abort(.unsupportedMediaType)
        }

        let validContentType = HTTPMediaType(type: "application", subType: "json")
        if contentType != validContentType {
            throw Abort(.unsupportedMediaType)
        }
    }
}
