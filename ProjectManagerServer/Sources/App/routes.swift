import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.group("things") { things in
        things.get { req -> EventLoopFuture<[ThingList]> in
            return State.allCases.map { state in
                Thing.query(on: req.db).filter(\.$state == state).all().map { things -> ThingList in
                    let thingSimples = things.compactMap { $0.response }
                    return ThingList(state: state, list: thingSimples)
                }
            }.flatten(on: req.eventLoop)
        }
        
        things.post { req -> EventLoopFuture<Response> in
            try ThingCreate.validate(content: req)
            let thingCreate = try req.content.decode(ThingCreate.self)
            
            let newThing = NewThing(title: thingCreate.title,
                                    description: thingCreate.description)
            
            if let dueDate = thingCreate.dueDate {
                newThing.dueDate = Date(timeIntervalSince1970: dueDate)
            }
            
            return newThing.save(on: req.db).flatMapThrowing {
                let header = ("Content-Type", "application/json; charset=utf-8")
                
                let id = try newThing.requireID()
                let body = ["id": id]
                let bodyJsonData = try JSONEncoder().encode(body)
                
                return Response(status: .created,
                                headers: HTTPHeaders(dictionaryLiteral: header),
                                body: .init(data: bodyJsonData))
            }
        }
        
        things.group(":id") { thing in
            thing.patch { req -> EventLoopFuture<HTTPResponseStatus> in
                try ThingUpdate.validate(content: req)
                let thingUpdate = try req.content.decode(ThingUpdate.self)
                return Thing.find(req.parameters.get("id"), on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { thing in
                        if let title = thingUpdate.title {
                            thing.title = title
                        }
                        
                        if let description = thingUpdate.description {
                            thing.description = description
                        }
                        
                        if let dueDateUnixDouble = thingUpdate.dueDate {
                            thing.dueDate = Date(timeIntervalSince1970: dueDateUnixDouble)
                        }
                        
                        if let state = thingUpdate.state {
                            thing.state = state
                        }
                        
                        return thing.save(on: req.db).transform(to: HTTPStatus.noContent)
                    }
            }
            
            thing.delete { req -> EventLoopFuture<HTTPResponseStatus> in
                return Thing.find(req.parameters.get("id"), on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { thing in
                        return thing.delete(on: req.db).transform(to: HTTPStatus.noContent)
                    }
            }
        }
    }
}
