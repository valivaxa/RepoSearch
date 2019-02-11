//
//  CachedRepoService.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

protocol CachedRepoServiceProtocol: AnyObject {
    func cacheRepositories(_ repositories: [Repository], overwriting: Bool)
    func fetchRepositories() -> [Repository]
}

final class CachedRepoService: CachedRepoServiceProtocol {
    private let cacheService = JSONCacheService.shared
    private let jsonFileName = "repos.json"
    
    func cacheRepositories(_ repositories: [Repository], overwriting: Bool) {
        self.cacheService.cacheData(repositories, fileName: self.jsonFileName, overwriting: overwriting)
    }
    
    func fetchRepositories() -> [Repository] {
        return self.cacheService.getData(fileName: self.jsonFileName) ?? []
    }
}
