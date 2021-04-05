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
        let items = routes.grouped("items")
        items.get(use: showAll)
        items.post(use: create)
    }
    
    func showAll(req: Request) throws -> EventLoopFuture<[Item]> {
        return Item.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Item> {
        let item = try req.content.decode(Item.self)
        return item.create(on: req.db).map { item }
    }
}
