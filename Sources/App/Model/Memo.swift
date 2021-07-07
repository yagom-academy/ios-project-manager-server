//
//  File.swift
//  
//
//  Created by 천수현 on 2021/07/03.
//

import Vapor
import Fluent

final class Memo: Model, Content {
    static let schema = "memos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "due_date")
    var due_date: Date
    
    @Enum(key: "memo_type")
    var memo_type: MemoType
    
    init() { }
    
    init(id: UUID? = nil,
         title: String,
         content: String,
         due_date: Date,
         memo_type: MemoType) {
        self.id = id
        self.title = title
        self.content = content
        self.due_date = due_date
        self.memo_type = memo_type
    }
}

extension Memo {
    enum MemoType: String, Codable {
        case todo
        case doing
        case done
    }
}
