import Vapor

struct ThingSimple: Content {
    let id: Int
    let title: String
    let description: String?
    let dueDate: Double?
    let updatedAt: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, description
        case dueDate = "due_date"
        case updatedAt = "updated_at"
    }
}
