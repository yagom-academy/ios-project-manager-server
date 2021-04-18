//
//  File.swift
//  
//
//  Created by 리나 on 2021/04/06.
//

import Vapor

struct EditedItem: Content {
    let title: String?
    let body: String?
    let state: State?
    let deadline: Double?
    
    enum CodingKeys: String, CodingKey {
        case title, body, state, deadline
    }
}

extension EditedItem: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(...500), required: false)
        validations.add("body", as: String.self, is: .count(...1000), required: false)
        validations.add("state", as: String.self, is: .in(State.allCases.map { $0.rawValue }), required: false)
        validations.add("deadline", as: Double?.self, required: false)
    }
}
