//
//  File.swift
//  
//
//  Created by 최정민 on 2021/07/06.
//

import Vapor

enum TaskError {
    case invalidContentType
}

extension TaskError: AbortError {
    var reason: String {
        switch self {
        case .invalidContentType:
            return "content type is not application/JSON"
        }
    }

    var status: HTTPResponseStatus {
        switch self {
        case .invalidContentType:
            return .badRequest
        }
    }
}
