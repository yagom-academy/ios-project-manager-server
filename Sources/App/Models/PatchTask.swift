//
//  PatchTask.swift
//  
//
//  Created by steven on 2021/07/05.
//

import Foundation

struct PatchTask: Decodable {
    let title: String?
    let deadline: Date?
    let state: State?
    let contents: String?
}
