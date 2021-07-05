//
//  TaskControllerError.swift
//  
//
//  Created by duckbok on 2021/07/05.
//

import Vapor

enum TaskControllerError {
    case contentTypeIsNotJSON
    case invalidID
    case idNotFound
    case patchTaskIsEmpty
}

extension TaskControllerError: AbortError {
    var status: HTTPResponseStatus {
        switch self {
        case .contentTypeIsNotJSON:
            return .unsupportedMediaType
        case .invalidID, .idNotFound:
            return .notFound
        case .patchTaskIsEmpty:
            return .noContent
        }
    }

    var reason: String {
        switch self {
        case .contentTypeIsNotJSON:
            return "Content-Type of request header must be application/json"
        case .invalidID:
            return "Parameter for ID must be number"
        case .idNotFound:
            return "ID does not exist"
        case .patchTaskIsEmpty:
            return ""
        }
    }
}
