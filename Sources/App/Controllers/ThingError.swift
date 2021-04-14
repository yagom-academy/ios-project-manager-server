//
//  ThingError.swift
//  
//
//  Created by 임성민 on 2021/04/13.
//

import Vapor

enum ThingError {
    case invalidState
    case notFoundID
    case tooLongDescription
}

extension ThingError: AbortError {
    var reason: String {
        switch self {
        case .invalidState:
            return "State is not valid."
        case .notFoundID:
            return "ID is not exist."
        case .tooLongDescription:
            return "Description cannot exceed 1000 characters."
        }
    }
    
    var status: HTTPResponseStatus {
        switch self {
        case .invalidState:
            return .badRequest
        case .notFoundID:
            return .notFound
        case .tooLongDescription:
            return .badRequest
        }
    }
}
