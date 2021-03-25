//
//  File.swift
//  
//
//  Created by Yeon on 2021/03/25.
//

import Vapor

struct TodoCreate: Content {
    let title: String
    let description: String?
    let deadline: Date?
    let status: Int
}
