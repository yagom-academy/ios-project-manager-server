import Vapor

enum ThingError {
    case invalidID
}

extension ThingError: AbortError {
    var reason: String {
        switch self {
        case .invalidID:
            return "ID is not integer"
        }
    }

    var status: HTTPStatus {
        switch self {
        case .invalidID:
            return .badRequest
        }
    }
}
