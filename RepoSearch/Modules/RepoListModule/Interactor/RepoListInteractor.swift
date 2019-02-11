//
//  RepoListInteractor.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation
import Reachability

final class RepoListInteractor {
    weak var output: RepoListInteractorOutput?
    private let remoteService: RemoteRepoServiceProtocol
    private let localService: CachedRepoServiceProtocol
    
    private var searchQuery = RepoSearchQuery(query: "", page: 1, perPage: 30)
    
    init(remoteService: RemoteRepoServiceProtocol, localService: CachedRepoServiceProtocol) {
        self.remoteService = remoteService
        self.localService = localService
    }
}

extension RepoListInteractor: RepoListInteractorInput {
    
    private var isReachable: Bool {
        return (Reachability()?.connection ?? .none) != .none
    }
    
    func fetchRepositories(searchText: String) {
        searchQuery.query = searchText
        searchQuery.page = 1
        fetchRepositories(query: searchQuery)
    }
    
    func fetchMoreRepositories() {
        // Perform fetch only for concrete search query when connection is present
        if isReachable && !searchQuery.query.isEmpty {
            searchQuery.page += 1
            fetchRepositories(query: searchQuery)
        } else {
            output?.repositoriesFetched([], shouldRefresh: false)
        }
    }
    
    private func fetchRepositories(query: RepoSearchQuery) {
        if isReachable && !searchQuery.query.isEmpty {
            self.fetchFromRemote(query: query)
        } else {
            // Fetch cached recent search results when query is empty or no connection is present
            self.fetchFromCache(query: query)
        }
    }
    
    private func fetchFromRemote(query: RepoSearchQuery) {
        let sortParams = RepoSortParams(criteria: .stars, order: .descending)
        remoteService.getRepositories(query: query, sort: sortParams) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .success(let repos):
                self.output?.repositoriesFetched(repos, shouldRefresh: query.page == 1)
                self.localService.cacheRepositories(repos, overwriting: query.page == 1)
            case .failure(let error):
                self.output?.fetchFailed(with: error.localizedDescription)
            }
        }
    }
    
    private func fetchFromCache(query: RepoSearchQuery) {
        let cachedRepos = self.localService.fetchRepositories()
        if cachedRepos.isEmpty {
            // Notify output about the reason of empty fetch results
            if query.query.isEmpty {
                self.output?.fetchFailed(with: "Input search query")
            } else {
                self.output?.fetchFailed(with: "The Internet connection appears to be offline")
            }
        } else {
            self.output?.repositoriesFetched(cachedRepos, shouldRefresh: true)
        }
    }
}
