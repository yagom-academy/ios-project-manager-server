//
//  File.swift
//  
//
//  Created by 김지혜 on 2021/03/11.
//

import Vapor

struct ThingCreate: Content {
    var title: String
    var description: String?
    var dueDate: Double?
    
    enum CodingKeys: String, CodingKey {
        case title, description
        case dueDate = "due_date"
    }
}
//struct Response: Content {
//    var error: Error?
//    var payload: Payload?
//}
//
//struct Payload: Content {
//    id: Int
//}
//
//struct Error: Content {
//    
//}
