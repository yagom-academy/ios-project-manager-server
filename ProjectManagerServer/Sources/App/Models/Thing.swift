import FluentPostgresDriver
import Vapor

final class Thing: Model {
    static let schema = "things"
    
    @ID(custom: "id", generatedBy: .database)
    var id: Int?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "description")
    var description: String?
    
    @Field(key: "due_date")
    var dueDate: Date?
    
    @Field(key: "state")
    var state: State?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
}

extension Thing {
    var response: ThingSimple? {
        guard let id = self.id else {
            return nil
        }
        
        return ThingSimple(
            id: id,
            title: self.title,
            description: self.description,
            dueDate: self.dueDate?.timeIntervalSince1970,
            updatedAt: self.updatedAt?.timeIntervalSince1970)
    }
}
