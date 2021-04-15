//
//  File.swift
//  
//
//  Created by 리나 on 2021/04/06.
//

import Vapor

enum ItemError: AbortError {
    case invalidID
    case noAccessToken
    case invalidAccessKey
    
    var reason: String {
        switch self {
        case .invalidID:
            return "id is not a(n) Integer"
        case .invalidAccessKey:
            return "Access Key is invalid"
        case .noAccessToken:
            return "Access Key is needed"
        }
    }
    
    var status: HTTPStatus {
        switch self {
        case .invalidID:
            return .badRequest
        case .invalidAccessKey:
            return .unauthorized
        case .noAccessToken:
            return .unauthorized
        }
    }
}
