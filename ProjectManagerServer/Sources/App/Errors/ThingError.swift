import Vapor

enum ThingError {
    case invalidId
}

extension ThingError: AbortError {
    var reason: String {
        switch self {
        case .invalidId:
            return "id is not integer"
        }
    }

    var status: HTTPStatus {
        switch self {
        case .invalidId:
            return .badRequest
        }
    }
}
