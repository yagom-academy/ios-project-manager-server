//
//  File.swift
//  
//
//  Created by TORI on 2021/08/04.
//

import Fluent
import Vapor

struct PatchTask: Decodable {
    let id: UUID?
    let title: String?
    let description: String?
    let deadline: Int?
    let status: String?
}
