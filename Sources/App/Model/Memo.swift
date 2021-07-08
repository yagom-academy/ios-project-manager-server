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

extension Memo: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)
        validations.add("content", as: String.self, is: !.empty)
        validations.add("due_date", as: Date.self, is: .valid)
        validations.add("memo_type", as: String.self, is: .in("todo", "doing", "done"))
    }
}
