import Vapor

struct ThingCreate: Content {
    var title: String
    var description: String?
    var dueDate: Double?
    
    enum CodingKeys: String, CodingKey {
        case title, description
        case dueDate = "due_date"
    }
}

extension ThingCreate: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(...500))
        validations.add("description", as: String.self, is: .count(...1000), required: false)
    }
}
