//
//  APIRequest.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

typealias HTTPHeader = [String: String]

protocol APIRequest {
    associatedtype Parameters: Encodable
    associatedtype Response: Decodable
    
    var endpoint: String { get }
    var header: HTTPHeader { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var queryItems: [URLQueryItem]? { get }
    var parametersData: Data? { get }
}

extension APIRequest {
    var header: HTTPHeader {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }
    
    var parametersData: Data? {
        guard let parameters = self.parameters else {
            return nil
        }
        let encoder = JSONEncoder()
        return try? encoder.encode(parameters)
    }
    
    var queryItems: [URLQueryItem]? { return nil }
}
