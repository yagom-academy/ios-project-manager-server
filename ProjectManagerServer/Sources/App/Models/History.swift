//
//  File.swift
//  
//
//  Created by 최정민 on 2021/07/04.
//

import Fluent
import Vapor

final class History: Model, Content {
    static let schema = "histories"

    @ID(key: .id)
    var id: UUID?

    @Enum(key: "action")
    var action: Action
    
    @OptionalEnum(key: "previous_status")
    var previousStatus: Status?
    
    @OptionalEnum(key: "changed_status")
    var changedStatus: Status?
    
    @OptionalField(key: "updated_title")
    var updatedTitle: String?

    @Field(key: "task_id")
    var taskId: String
        
    init() { }

    init(id: UUID? = nil,
         action: Action,
         previousStatus: Status? = nil,
         changedStatus: Status? = nil,
         updatedTitle: String? = nil,
         taskId: String) {
        self.id = id
        self.action = action
        self.previousStatus = previousStatus
        self.changedStatus = changedStatus
        self.updatedTitle = updatedTitle
        self.taskId = taskId
    }
}

enum Action: String, Codable {
    case moved, updated, added, removed
}
