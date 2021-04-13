//
//  File.swift
//  
//
//  Created by 임성민 on 2021/04/13.
//

import Vapor

struct ThingToUpdate: Content {
    var title: String?
    var description: String?
    var state: Thing.State?
    var dueDate: Double?
}
