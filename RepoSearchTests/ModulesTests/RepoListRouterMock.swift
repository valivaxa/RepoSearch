//
//  RepoListRouterMock.swift
//  RepoSearch
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation
@testable import RepoSearch

class RepoListRouterMock: RepoListRouterInput {
    var didCallShowDetails = false
    var repository: Repository?
    
    func showDetails(for repository: Repository) {
        self.didCallShowDetails = true
        self.repository = repository
    }
}
