import Vapor
import Fluent

final class Thing: Model, Content {
    static let schema = "things"
    
    @ID(key: .id)
    var id: UUID?
    
    @OptionalField(key: "title")
    var title: String?
    
    @OptionalField(key: "description")
    var description: String?
    
    @Enum(key: "state")
    var state: State
    
    @Field(key: "due_date")
    var dueDate: Double
    
    @Timestamp(key: "updated_at", on: .create)
    var updatedAt: Date?
    
    enum State: String, Codable {
        case todo, doing, done
    }
    
    init() { }
    
    init(id: UUID? = nil,
         title: String? = nil,
         description: String? = nil,
         state: State,
         dueDate: Double,
         updatedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.state = state
        self.dueDate = dueDate
        self.updatedAt = updatedAt
    }
}

extension Thing: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("state", as: String.self, is: .in("todo", "doing", "done"), required: true)
        validations.add("description", as: String?.self, is: .count(...1000), required: false)
    }
}
