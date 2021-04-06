//
//  File.swift
//  
//
//  Created by 리나 on 2021/04/06.
//

import Vapor

enum ItemError: AbortError {
    case invalidID
    
    var reason: String {
        switch self {
        case .invalidID:
            return "ID must be integer type."
    }
    
    var status: HTTPStatus {
        switch self {
        case .invalidID:
            return .badRequest
    }
}
