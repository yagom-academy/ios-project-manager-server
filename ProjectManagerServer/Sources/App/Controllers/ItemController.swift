//
//  File.swift
//  
//
//  Created by sole on 2021/04/05.
//

import Fluent
import Vapor

struct ItemController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let router = routes.grouped(Item.schema.pathComponents)
        router.get(use: showAll)
    }
    
    func showAll(req: Request) throws -> EventLoopFuture<[Item]> {
        return Item.query(on: req.db).all()
    }
}
