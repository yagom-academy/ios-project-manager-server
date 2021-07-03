import Fluent
import Vapor

final class Task: Model, Content {
    static let schema = "task"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Enum(key: "status")
    var status: Status
    
    @Field(key: "description")
    var description: String

    @Timestamp(key: "date", on: .create)
    var date: Date?

    init() { }

    init(id: UUID? = nil,
         title: String,
         status: Status,
         description: String,
         date: Date? = nil) {
        self.id = id
        self.title = title
        self.status = status
        self.description = description
        self.date = date
    }
}

enum Status: String, Codable {
    case toDo, doing, done
}
