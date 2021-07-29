//
//  File.swift
//  
//
//  Created by YB on 2021/07/29.
//

import Vapor

enum HTTPError {
    case notExistID
    case isNotDecoded
    case isValidContentType
}

extension HTTPError: AbortError {

    var reason: String {
        switch self {
        case .notExistID:
            return "ID does not exist."
        case .isNotDecoded:
            return "Data is not decoded to Task type."
        case .isValidContentType:
            return "The Content-Type of the request is not Valid"
        }
    }
    
    var status: HTTPResponseStatus {
        switch self {
        case .notExistID:
            return .notFound
        case .isNotDecoded:
            return .badRequest
        case .isValidContentType:
            return .badRequest
        }
    }
}
