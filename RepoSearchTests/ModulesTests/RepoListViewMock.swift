//
//  RepoListViewMock.swift
//  RepoSearch
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation
@testable import RepoSearch

class RepoListViewMock: RepoListView {
    
    var didCallSetRepositories = false
    var didCallAppendRepositories = false
    var didCallDisplayEmptyResults = false
    var didCallShowActivityIndicator = false
    var didCallHideActivityIndicator = false
    var didCallClearSelection = false
    
    var repositories = [RepositoryViewModel]()
    
    func setRepositories(_ repositories: [RepositoryViewModel]) {
        self.didCallSetRepositories = true
    }
    
    func appendRepositories(_ repositories: [RepositoryViewModel]) {
        self.didCallAppendRepositories = true
    }
    
    func displayEmptyResults(placeholder: String) {
        self.didCallDisplayEmptyResults = true
    }
    
    func showActivityIndicator() {
        self.didCallShowActivityIndicator = true
    }
    
    func hideActivityIndicator() {
        self.didCallHideActivityIndicator = true
    }
    
    func clearSelection() {
        self.didCallClearSelection = true
    }
}
