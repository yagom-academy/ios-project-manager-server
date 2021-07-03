import Fluent
import Vapor

final class History: Model, Content {
    static let schema = "history"

    @ID(key: .id)
    var id: UUID?

    @Enum(key: "action")
    var action: Action
    
    @OptionalField(key: "previous_status")
    var previousStatus: String?
    
    @OptionalField(key: "changed_status")
    var changedStatus: String?
    
    @OptionalField(key: "updated_title")
    var updatedTitle: String?
    
    @Field(key: "task")
    var task: Task

    init() { }

    init(id: UUID? = nil,
         action: Action,
         previousStatus: String? = nil,
         changedStatus: String? = nil,
         updatedTitle: String? = nil,
         task: Task) {
        self.id = id
        self.action = action
        self.previousStatus = previousStatus
        self.changedStatus = changedStatus
        self.updatedTitle = updatedTitle
        self.task = task
    }
}

enum Action: String, Codable {
    case moved, added, removed
}
