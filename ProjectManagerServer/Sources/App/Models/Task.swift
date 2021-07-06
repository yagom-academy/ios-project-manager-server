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
    var date: Int
        
    @Enum(key: "status")
    var status: Status
    
    init() { }
    
    init(id: UUID? = nil,
         title: String,
         description: String,
         date: Int,
         status: Status) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.status = status
    }
}
       
extension Task: Validatable {
    static func validations(_ validations: inout Validations) {
       
        validations.add("id", as: String.self, is: .count(36...36))
        validations.add("title", as: String.self, is: !.empty)
        validations.add("status", as: String.self, is: .in("toDo", "doing", "done"))
        validations.add("description", as: String.self, is: .count(0...1000))
        validations.add("date", as: Int.self, is: .range(1625497069...9999999999))
    }
}

enum Status: String, Codable {
    case toDo, doing, done
}
