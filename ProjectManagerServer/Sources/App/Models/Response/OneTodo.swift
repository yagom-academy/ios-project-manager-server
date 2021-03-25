//
//  OneTodo.swift
//  
//
//  Created by Yeon on 2021/03/25.
//

import Vapor

struct OneTodo: Content {
    let id: Int
    let title: String
    let description: String?
    let deadline: Date?
    let status: Int
}
