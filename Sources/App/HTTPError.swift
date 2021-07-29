//
//  File.swift
//  
//
//  Created by YB on 2021/07/29.
//

import Vapor

enum HTTPError {
    case idTypeisnotUUID
    case notExistID
    case overNumberOfCharacters
    case isNotString
    case isNotDouble
}

extension HTTPError: AbortError {

    var reason: String {
        switch self {
        case .idTypeisnotUUID:
            return "The type of ID requested is not UUID type."
        case .notExistID:
            return "ID does not exist."
        case .overNumberOfCharacters:
            return "Description is more than 1000 characters."
        case .isNotString:
            return "The requested body does not have String type."
        case .isNotDouble:
            return "The requested body does not have Double type."
        }
    }
    
    var status: HTTPResponseStatus {
        switch self {
        case .idTypeisnotUUID:
            return .badRequest
        case .notExistID:
            return .notFound
        case .overNumberOfCharacters:
            return .badRequest
        case .isNotString:
            return .badRequest
        case .isNotDouble:
            return .badRequest
        }
    }
}
