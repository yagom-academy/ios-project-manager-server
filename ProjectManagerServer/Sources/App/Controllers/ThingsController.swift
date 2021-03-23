//
//  File.swift
//  
//
//  Created by iluxsm on 2021/03/23.
//

import Vapor
import Fluent

struct ThingsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let things = routes.grouped("things")
        things.get(use: fetch)
        things.post(use: create)

        things.group(":id") { thing in
            thing.put(use: update)
            thing.delete(use: delete)
        }
    }

    func fetch(req: Request) throws -> EventLoopFuture<[ThingList]> {
        return State.allCases.map { state in
            Thing.query(on: req.db).filter(\.$state == state).all().map { things -> ThingList in
                let thingSimples = things.compactMap { $0.response }
                return ThingList(state: state, list: thingSimples)
            }
        }.flatten(on: req.eventLoop)
    }

    func create(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        try ThingCreate.validate(content: req)
        let thingCreate = try req.content.decode(ThingCreate.self)

        let newThing = NewThing(title: thingCreate.title,
                                description: thingCreate.description)

        if let dueDate = thingCreate.dueDate {
            newThing.dueDate = Date(timeIntervalSince1970: dueDate)
        }

        return newThing.save(on: req.db).transform(to: HTTPStatus.created)
    }

    func update(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
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

    func delete(req: Request) throws -> EventLoopFuture<HTTPResponseStatus> {
        return Thing.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { thing in
                return thing.delete(on: req.db).transform(to: HTTPStatus.noContent)
            }
    }
}
