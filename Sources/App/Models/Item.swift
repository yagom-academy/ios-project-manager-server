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
    
    @Field(key: "state")
    var state: String

    @Field(key: "deadline")
    var deadline: Number?
    
    @Field(key: "last_modified")
    var last_modified: Number
    
    init() { }

    init(id: UUID? = nil, title: String, body: String, state: String, deadline: Number, last_modified: Number) {
        self.id = id
        self.title = title
        self.body = body
        self.state = state
        self.deadline = deadline
        self.last_modified = last_modified
    }
}
