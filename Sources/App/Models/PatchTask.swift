//
//  PatchTask.swift
//  
//
//  Created by steven on 2021/07/05.
//

import Vapor

struct PatchTask: Decodable, Content {
    let title: String?
    let deadline: Date?
    let state: State?
    let contents: String?

    var isEmpty: Bool {
        let isEmpty = title == nil
                   && deadline == nil
                   && state == nil
                   && contents == nil
        return isEmpty
    }
}

extension PatchTask: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(1...50), required: false)
        validations.add("state", as: String.self, is: .in(State.description), required: false)
        validations.add("deadline", as: Double.self, is: .range(0...253402182000), required: false)
        validations.add("contents", as: String.self, is: .count(1...1000), required: false)
    }
}
