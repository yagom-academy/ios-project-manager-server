import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.group("things") { things in
        things.get { req -> EventLoopFuture<[ThingList]> in
            return State.allCases.map { state in
                Thing.query(on: req.db).filter(\.$state == state).all().map { things -> ThingList in
                    var thingSimples: [ThingSimple] = []
                    for thing in things {
                        if let id = thing.id,
                           let dueDate = thing.dueDate {
                            let thingSimple = ThingSimple(
                                id: id,
                                title: thing.title,
                                description: thing.description,
                                dueDate: dueDate.timeIntervalSince1970
                            )
                            thingSimples.append(thingSimple)
                        }
                    }
                    return ThingList(state: state, list: thingSimples)
                }
            }.flatten(on: req.eventLoop)
        }
        
        things.post { req -> EventLoopFuture<HTTPResponseStatus> in
            try ThingCreate.validate(content: req)
            let thingCreate = try req.content.decode(ThingCreate.self)
            
            let newThing = NewThing(title: thingCreate.title,
                              description: thingCreate.description)
            
            if let dueDate = thingCreate.dueDate {
                newThing.dueDate = Date(timeIntervalSince1970: dueDate)
            }
            
            return newThing.save(on: req.db).transform(to: HTTPStatus.created)
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
