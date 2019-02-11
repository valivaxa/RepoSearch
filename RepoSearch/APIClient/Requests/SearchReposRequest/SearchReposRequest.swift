//
//  SearchReposRequest.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

struct SearchReposRequest: APIRequest {
    typealias Parameters = String
    typealias Response = RepoSearchResponse
    
    let query: RepoSearchQuery
    let sort: RepoSortParams
    
    var endpoint: String {
        return "/search/repositories"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            URLQueryItem(name: "q", value: query.query),
            URLQueryItem(name: "page", value: "\(query.page)"),
            URLQueryItem(name: "per_page", value: "\(query.perPage)"),
            URLQueryItem(name: "sort", value: "\(sort.criteria.rawValue)"),
            URLQueryItem(name: "order", value: "\(sort.order.rawValue)")
        ].filter({ $0.value != nil && !$0.value!.isEmpty })
    }
    
    var parameters: String? {
        return nil
    }
}
