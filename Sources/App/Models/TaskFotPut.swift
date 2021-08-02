//
//  File.swift
//  
//
//  Created by 김찬우 on 2021/08/02.
//

import Foundation

struct TaskForPut: Codable {
    let title: String
    let description: String
    let dueDate: Double
    let status: Status
}
