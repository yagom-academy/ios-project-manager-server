import Fluent
import Vapor

final class Item: Model, Content {
    static let schema = "items"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?

    @Field(key: "title")
    var title: String
    
    @Field(key: "body")
    var body: String
    
    @Enum(key: "state")
    var state: State

    @OptionalField(key: "deadline")
    var deadline: Double?
    
    @Timestamp(key: "last_modified", on: .update)
    var last_modified: Date?
    
    init() { }

    init(id: Int? = nil,
         title: String,
         body: String,
         state: State,
         deadline: Double? = nil,
         last_modified: Date? = nil) {
        self.id = id
        self.title = title
        self.body = body
        self.state = state
        self.deadline = deadline
        self.last_modified = last_modified
    }
}
