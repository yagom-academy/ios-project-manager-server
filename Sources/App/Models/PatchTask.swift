//
//  PatchTask.swift
//  
//
//  Created by steven on 2021/07/05.
//

import Vapor

struct PatchTask: Decodable {
    let title: String?
    let deadline: Date?
    let state: State?
    let contents: String?

    var isEmpty: Bool {
        return title == nil
            && deadline == nil
            && state == nil
            && contents == nil
    }
}
