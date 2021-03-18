import Vapor

struct ThingUpdate: Content {
    var title: String?
    var description: String?
    var dueDate: Double?
    var state: State?
    
    enum CodingKeys: String, CodingKey {
        case title, description, state
        case dueDate = "due_date"
    }
}

extension ThingUpdate: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(...500), required: false)
        validations.add("description", as: String.self, is: .count(...1000), required: false)
        validations.add("state", as: String.self, is: .in(State.allCases.map { $0.rawValue }), required: false)
    }
}
