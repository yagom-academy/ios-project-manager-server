//
//  File.swift
//  
//
//  Created by 김찬우 on 2021/07/23.
//

import Vapor
import Fluent

final class Task: Model, Content {
    static let schema = "tasks"
}
