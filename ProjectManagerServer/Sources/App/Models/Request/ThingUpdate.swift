import Vapor

struct ThingUpdate: Content {
    let title: String?
    let description: String?
    let dueDate: Double?
    let state: State?
    
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
