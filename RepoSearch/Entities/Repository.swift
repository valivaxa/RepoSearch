//
//  Repository.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

struct Repository: Codable {
    let name: String
    let owner: RepoOwner
    let pageUrl: String
    let description: String?
    let stars: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case owner
        case pageUrl = "html_url"
        case description
        case stars = "watchers_count"
    }
}
