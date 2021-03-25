//
//  TodoError.swift
//  
//
//  Created by Yeon on 2021/03/25.
//
import Vapor

enum TodoError: AbortError {
    case invalidID
    
    var description: String {
        switch self {
        case .invalidID:
            return "요청하신 id의 타입이 일치하지 않습니다."
        }
    }
    
    var status: HTTPStatus {
        switch self {
        case .invalidID:
            return .badRequest
        }
    }
}
