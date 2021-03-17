//
//  ThingError.swift
//  
//
//  Created by 김지혜 on 2021/03/16.
//

import Vapor

enum ThingError {
    case userNotLoggedIn
    case invalidEmail(String)
}

extension ThingError: AbortError {
    var reason: String {
        switch self {
        case .userNotLoggedIn:
            return "User is not logged in."
        case .invalidEmail(let email):
            return "Email address is not valid: \(email)."
        }
    }

    var status: HTTPStatus {
        switch self {
        case .userNotLoggedIn:
            return .unauthorized
        case .invalidEmail:
            return .badRequest
        }
    }
}
