//
//  File.swift
//  
//
//  Created by 천수현 on 2021/07/08.
//

import Vapor
import Fluent

struct PatchMemo: Decodable {
    var title: String?
    var content: String?
    var due_date: Date?
    var memo_type: MemoType?
}
