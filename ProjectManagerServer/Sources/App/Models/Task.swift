import Fluent
import Vapor

final class Task: Model, Content {
    static let schema = "tasks"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "description")
    var description: String
    
    @Field(key: "date")
    var date: Double
    
    @Enum(key: "status")
    var status: Status
    
    init() { }

    init(id: UUID? = nil,
         title: String,
         description: String,
         date: Double,
         status: Status) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.status = status
    }
}

enum Status: String, Codable {
    case toDo, doing, done
}
