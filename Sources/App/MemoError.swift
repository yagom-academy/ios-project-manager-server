//
//  File.swift
//  
//
//  Created by 천수현 on 2021/07/08.
//

import Vapor

enum MemoError: AbortError {
    case notFound
    case contentTypeIsNotJSON
    case wrongParameter
    
    var reason: String {
        switch self {
        case .notFound:
            return "해당 Id를 가진 메모를 찾을수 없습니다."
        case .contentTypeIsNotJSON:
            return "Content-Type은 application/json이어야 합니다."
        case .wrongParameter:
            return "memo-id의 형식은 UUID여야 합니다."
        }
    }

    var status: HTTPResponseStatus {
        switch self {
        case .notFound:
            return .notFound
        case .contentTypeIsNotJSON:
            return .badRequest
        case .wrongParameter:
            return .badRequest
        }
    }
}
