//
//  ProjectItem.swift
//  
//
//  Created by Wody, Kane, Ryan-Son on 2021/07/02.
//

import Fluent
import Vapor

final class ProjectItem: Model, Content {
    static let schema = "projectItems"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "content")
    var content: String
    
    @Field(key: "deadlineDate")
    var deadlineDate: Date
    
    @Field(key: "progress")
    var progress: String
    
    init() { }
    
    init(id: UUID? = nil, title: String, content: String, deadlineDate: Date, progress: String) {
        self.id = id
        self.title = title
        self.content = content
        self.deadlineDate = deadlineDate
        self.progress = progress
    }
}
