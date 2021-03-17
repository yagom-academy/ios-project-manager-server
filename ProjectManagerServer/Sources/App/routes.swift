import Fluent
import Vapor

// TODO: 응답에 바디 없는 것들은 204 No Content 로 바꾸기
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
        
        things.post { req -> EventLoopFuture<ThingSimple> in
            try ThingCreate.validate(content: req)
            let thingCreate = try req.content.decode(ThingCreate.self)
            
            let newThing = NewThing(title: thingCreate.title,
                              description: thingCreate.description)
            
            if let dueDate = thingCreate.dueDate {
                newThing.dueDate = Date(timeIntervalSince1970: dueDate)
            }
            
            return newThing.save(on: req.db).flatMapThrowing {
                let id = try newThing.requireID()
                var thingSimple = ThingSimple(
                    id: id,
                    title: newThing.title,
                    description: newThing.description)
                
                if let dueDate = newThing.dueDate {
                    thingSimple.dueDate = dueDate.timeIntervalSince1970
                }
                
                return thingSimple
            }
        }
        
        things.group(":id") { thing in
            thing.patch { req -> EventLoopFuture<ThingSimple> in
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
                        // no content
                        // thing.save(on: req.db).transform(to: HTTPStatus.created)
                        // -> HTTPResponseStatus
                        
                        return thing.save(on: req.db).flatMapThrowing {
                            guard let response = thing.response else {
                                throw FluentError.idRequired
                            }

                            return response
                        }
                    }
            }
            
            thing.delete { req -> EventLoopFuture<ThingSimple> in
                return Thing.find(req.parameters.get("id"), on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { thing in
                        return thing.delete(on: req.db).flatMapThrowing {
                            guard let response = thing.response else {
                                throw FluentError.idRequired
                            }

                            return response
                        }
                    }
            }
        }
    }
}
