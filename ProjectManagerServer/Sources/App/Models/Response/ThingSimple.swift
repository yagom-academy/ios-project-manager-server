//
//  ThingSimple.swift
//  
//
//  Created by 김지혜 on 2021/03/13.
//

import Vapor

struct ThingSimple: Content {
    var id: Int
    var title: String
    var description: String?
    var dueDate: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case dueDate = "due_date"
    }
}
