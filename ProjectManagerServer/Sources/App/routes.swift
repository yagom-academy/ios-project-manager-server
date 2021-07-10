//
//  routes.swift
//
//
//  Created by Wody, Kane, Ryan-Son on 2021/07/02.
//

import Vapor
import Fluent

func routes(_ app: Application) throws {
    try app.register(collection: ProjectItemController())
}
