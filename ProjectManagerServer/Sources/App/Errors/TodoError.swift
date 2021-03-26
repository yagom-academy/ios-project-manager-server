//
//  TodoError.swift
//  
//
//  Created by Yeon on 2021/03/25.
//
import Vapor

enum TodoError: AbortError {
    case invalidIDType
    case notMatchID
    
    var description: String {
        switch self {
        case .invalidIDType:
            return "요청하신 id의 타입이 일치하지 않습니다."
        case .notMatchID:
            return "요청하신 id가 url과 일치하지 않습니다."
        }
    }
    
    var status: HTTPStatus {
        switch self {
        case .invalidIDType:
            return .badRequest
        case .notMatchID:
            return .badRequest
        }
    }
}
