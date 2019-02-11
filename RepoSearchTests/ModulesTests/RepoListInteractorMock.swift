//
//  RepoListInteractorMock.swift
//  RepoSearchTests
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation
@testable import RepoSearch

class RepoListInteractorMock: RepoListInteractorInput {
    var didCallFetchRepositories = false
    var didCallFetchMore = false
    
    func fetchRepositories(searchText: String) {
        self.didCallFetchRepositories = true
    }
    
    func fetchMoreRepositories() {
        self.didCallFetchMore = true
    }
}
