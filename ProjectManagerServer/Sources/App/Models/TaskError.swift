//
//  TaskError.swift
//  
//
//  Created by KangKyung, James on 2021/07/30.
//

import Vapor

enum TaskError {
    case contentTypeIsNotJson
}

extension TaskError: AbortError {
    var reason: String {
        switch self {
        case .contentTypeIsNotJson:
            return "Content-Type is Not application/json"
        }
    }

    var status: HTTPResponseStatus {
        switch self {
        case .contentTypeIsNotJson:
            return .badRequest
        }
    }
}

