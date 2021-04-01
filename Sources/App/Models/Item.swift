import Fluent
import Vapor

final class Item: Model, Content {
    static let schema = "items"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String
    
    @Field(key: "body")
    var body: String
    
    @Enum(key: "state")
    var state: State

    @Timestamp(key: "deadline")
    var deadline: Number?
    
    @Timestamp(key: "last_modified", on: .update)
    var last_modified: Number?
    
    enum State: String, Codable {
        case todo, doing, done
    }
    
    init() { }

    init(id: UUID? = nil,
         title: String,
         body: String,
         state: State,
         deadline: Number? = nil,
         last_modified: Number? = nil) {
        self.id = id
        self.title = title
        self.body = body
        self.state = state
        self.deadline = deadline
        self.last_modified = last_modified
    }
}
