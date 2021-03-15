//
//  ThingUpdate.swift
//  
//
//  Created by 김지혜 on 2021/03/13.
//

import Vapor

struct ThingUpdate: Content {
    var title: String?
    var description: String?
    var dueDate: Double?
    var state: State?
    
    enum CodingKeys: String, CodingKey {
        case title, description, state
        case dueDate = "due_date"
    }
}
