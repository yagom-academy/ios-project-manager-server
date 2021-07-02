//
//  routes.swift
//
//
//  Created by Wody, Kane, Ryan-Son on 2021/07/02.
//

import Vapor
import Fluent

func routes(_ app: Application) throws {
    let projectItemController = ProjectItemController()
    app.get("projectItems", ":progress", use: projectItemController.read(req:))
    app.post("projectItem", use: projectItemController.create(req:))
    app.patch("projectItem", use: projectItemController.update(req:))
    app.delete("projectItem", use: projectItemController.delete(req:))
}
