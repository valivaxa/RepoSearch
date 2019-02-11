//
//  RepoListPresenter.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

private extension RepositoryViewModel {
    init(repository: Repository) {
        self.title = repository.name.trimmingToLength(30)
        self.description = repository.description?.trimmingToLength(30) ?? ""
        self.ownerName = repository.owner.login
        self.ownerImageUrl = repository.owner.avatarUrl
        self.starsCount = repository.stars
    }
}

final class RepoListPresenter {
    weak var view: RepoListView?
    private let interactor: RepoListInteractorInput
    private let router: RepoListRouterInput
    
    var repositories: [Repository] = []
    private var searchWorker: DispatchWorkItem?
    
    init(interactor: RepoListInteractorInput, router: RepoListRouterInput) {
        self.interactor = interactor
        self.router = router
    }
}

extension RepoListPresenter: RepoListViewOutput {
    func viewDidLoad() {
        view?.showActivityIndicator()
        interactor.fetchRepositories(searchText: "")
    }
    
    func viewWillAppear() {
        view?.clearSelection()
    }
    
    func didChangeSearchText(_ searchText: String) {
        view?.showActivityIndicator()
        searchWorker?.cancel()
        searchWorker = DispatchWorkItem(block: { [weak self] in
            guard let `self` = self else { return }
            self.interactor.fetchRepositories(searchText: searchText)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: searchWorker!)
    }
    
    func didScrollToIndex(_ index: Int) {
        if index == self.repositories.count - 1 {
            self.view?.showActivityIndicator()
            self.interactor.fetchMoreRepositories()
        }
    }
    
    func didSelectRepository(at index: Int) {
        let repository = self.repositories[index]
        self.router.showDetails(for: repository)
    }
}

extension RepoListPresenter: RepoListInteractorOutput {
    func repositoriesFetched(_ repositories: [Repository], shouldRefresh: Bool) {
        view?.hideActivityIndicator()
        let viewModels = repositories.map({ RepositoryViewModel(repository: $0) })
        if shouldRefresh {
            self.repositories = repositories
            self.view?.setRepositories(viewModels)
        } else {
            self.repositories.append(contentsOf: repositories)
            self.view?.appendRepositories(viewModels)
        }
    }
    
    func fetchFailed(with message: String) {
        view?.hideActivityIndicator()
        view?.displayEmptyResults(placeholder: message)
    }
}
