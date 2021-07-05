//
//  HTTPError.swift
//  
//
//  Created by Wody, Kane, Ryan-Son on 2021/07/05.
//

import Vapor

enum HTTPError {
    case progressNotFoundInURL
    case invalidProgressInURL
    case invalidContentType
    case validationFailedWhileCreating
    case validationFailedWhileUpdating
    case invalidID
}

extension HTTPError: AbortError {
    
    var reason: String {
        switch self {
        case .progressNotFoundInURL:
            return "This path requires progress as path parameter. Please enter \"/todo\", \"/doing\" or \"/done\" additively."
        case .invalidProgressInURL:
            return "Progresses are classified as todo, doing and done. Please check entered URL."
        case .invalidContentType:
            return "The Content-Type of the request is not application/json."
        case .validationFailedWhileCreating:
            return "Validations are failed while creating data. Please check if the content is not exceed length of 1000, progress is in todo, doing and done."
        case .validationFailedWhileUpdating:
            return "Validations are failed while updating data. Please check if the content has id, not to exceed length of 1000, and the progress is in todo, doing and done."
        case .invalidID:
            return "You have entered invalid projectItem ID. The database does not have such item."
        }
    }
    
    var status: HTTPResponseStatus {
        switch self {
        case .progressNotFoundInURL:
            return .notFound
        case .invalidProgressInURL:
            return .notFound
        case .invalidContentType:
            return .badRequest
        case .validationFailedWhileCreating:
            return .badRequest
        case .validationFailedWhileUpdating:
            return .badRequest
        case .invalidID:
            return .notFound
        }
    }
}
