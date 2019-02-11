//
//  RepoListContract.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

protocol RepoListView: IndicatableView {
    func setRepositories(_ repositories: [RepositoryViewModel])
    func appendRepositories(_ repositories: [RepositoryViewModel])
    func displayEmptyResults(placeholder: String)
    func clearSelection()
}

protocol RepoListViewOutput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didChangeSearchText(_ searchText: String)
    func didScrollToIndex(_ index: Int)
    func didSelectRepository(at index: Int)
}

protocol RepoListInteractorOutput: AnyObject {
    func repositoriesFetched(_ repositories: [Repository], shouldRefresh: Bool)
    func fetchFailed(with message: String)
}

protocol RepoListInteractorInput: AnyObject {
    func fetchRepositories(searchText: String)
    func fetchMoreRepositories()
}

protocol RepoListRouterInput: AnyObject {
    func showDetails(for repository: Repository)
}
