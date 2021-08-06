//
//  TaskError.swift
//  
//
//  Created by KangKyung, James on 2021/07/30.
//

import Vapor

enum TaskError {
    case contentTypeIsNotJson
    case allValuesAreNil
}

extension TaskError: AbortError {
    var reason: String {
        switch self {
        case .contentTypeIsNotJson:
            return "Content-Type is Not application/json"
        case .allValuesAreNil:
            return "All Values of json file are nil"
        }
    }

    var status: HTTPResponseStatus {
        switch self {
        case .contentTypeIsNotJson:
            return .badRequest
        case .allValuesAreNil:
            return .badRequest
        }
    }
}

