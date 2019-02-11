//
//  RepoListPresenterMock.swift
//  RepoSearchTests
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation
@testable import RepoSearch

class RepoListPresenterMock: RepoListInteractorOutput {
    var didCallRepositoryFetched = false
    var didCallFetchFailed = false
    var repositories = [Repository]()
    
    func repositoriesFetched(_ repositories: [Repository], shouldRefresh: Bool) {
        self.didCallRepositoryFetched = true
        if shouldRefresh {
            self.repositories = repositories
        } else {
            self.repositories.append(contentsOf: repositories)
        }
    }
    
    func fetchFailed(with message: String) {
        self.didCallFetchFailed = true
        
    }
}
