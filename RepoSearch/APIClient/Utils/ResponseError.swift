//
//  ResponseError.swift
//  RepoSearch
//
//  Created by valivaxa on 2/11/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

enum ResponseError: LocalizedError {
    case decoding
    case server(message: String, code: Int)
    case internetConnection
    
    var errorDescription: String? {
        switch self {
        case .internetConnection:
            return "Internet connection appears to be offline."
        case .server(let message, _):
            return message
        case .decoding:
            return "Something went wrong."
        }
    }
    
}
