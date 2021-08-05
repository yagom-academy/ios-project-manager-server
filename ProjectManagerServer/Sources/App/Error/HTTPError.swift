//
//  File.swift
//  
//
//  Created by kio on 2021/08/05.
//

import Vapor

enum HTTPError {
    case notFoundURL
    case invalidContentType
    case failedToCreatingValidation
    case failedToUpdatingValidation
    case invalidID
}

extension HTTPError: AbortError {
    
    var reason: String {
        switch self {
        case .notFoundURL:
            return "URL을 확인할 수 없습니다. 다시 확인해주세요."
        case .invalidContentType:
            return "The Content-Type of the request is not application/json."
        case .failedToCreatingValidation:
            return "데이터 생성에 실패하였습니다."
        case .failedToUpdatingValidation:
            return "데이터 업데이트에 실패하였습니다."
        case .invalidID:
            return "유효하지 않은 ID값입니다."
        }
    }
    
    var status: HTTPResponseStatus {
        switch self {
        case .notFoundURL:
            return .notFound
        case .invalidContentType:
            return .badRequest
        case .failedToCreatingValidation:
            return .badRequest
        case .failedToUpdatingValidation:
            return .badRequest
        case .invalidID:
            return .notFound
        }
    }
}
