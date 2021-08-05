//
//  File.swift
//  
//
//  Created by kio on 2021/08/05.
//

import Vapor

enum TaskError {
    case invalidStatus
    case notFoundForID
}

extension TaskError: AbortError {
    var reason: String {
        switch self {
        case .invalidStatus:
            return "Status is not valid"
        case .notFoundForID:
            return "Cannot find task for ID"
        }
    }

    var status: HTTPResponseStatus {
        switch self {
        case .invalidStatus:
            return .badRequest
        case .notFoundForID:
            return .notFound
        }
    }
}
