//
//  RepoListInteractorTests.swift
//  RepoSearchTests
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import XCTest
@testable import RepoSearch

class RemoteServiceMock: RemoteRepoServiceProtocol {
    var repositories = [Repository]()
    var error: Error?
    
    func getRepositories(query: RepoSearchQuery, sort: RepoSortParams,
                         completion: @escaping (Result<[Repository]>) -> Void) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(repositories))
        }
    }
    
    
}

class LocalServiceMock: CachedRepoServiceProtocol {
    var repositories = [Repository]()
    
    func cacheRepositories(_ repositories: [Repository], overwriting: Bool) {
        if overwriting {
            self.repositories = repositories
        } else {
            self.repositories.append(contentsOf: repositories)
        }
    }
    
    func fetchRepositories() -> [Repository] {
        return repositories
    }
}


class RepoListInteractorTests: XCTestCase {

    var outputMock: RepoListPresenterMock!
    var remoteServiceMock: RemoteServiceMock!
    var localServiceMock: LocalServiceMock!
    var interactor: RepoListInteractor!
    let repositories = [Repository(name: "test1", owner: RepoOwner(login: "name1", avatarUrl: ""),
                                   pageUrl: "", description: "", stars: 1),
                        Repository(name: "test2", owner: RepoOwner(login: "name2", avatarUrl: ""),
                                   pageUrl: "", description: "", stars: 1)]
    
    
    override func setUp() {
        outputMock = RepoListPresenterMock()
        remoteServiceMock = RemoteServiceMock()
        localServiceMock = LocalServiceMock()
        interactor = RepoListInteractor(remoteService: remoteServiceMock, localService: localServiceMock)
        interactor.output = outputMock
    }

    func testRemoteFetch() {
        remoteServiceMock.repositories = self.repositories
        interactor.fetchRepositories(searchText: "test")
        XCTAssert(outputMock.didCallRepositoryFetched)
    }
    
    func testResponseCaching() {
        remoteServiceMock.repositories = self.repositories
        interactor.fetchRepositories(searchText: "test")
        XCTAssert(remoteServiceMock.repositories == localServiceMock.repositories)
    }
    
    func testFetchFailed() {
        remoteServiceMock.error = NSError(domain: "tests", code: 0, userInfo: nil)
        interactor.fetchRepositories(searchText: "test")
        XCTAssert(outputMock.didCallFetchFailed)
    }
    
    func testEmptySearchCached() {
        remoteServiceMock.repositories = [Repository(name: "remote", owner: RepoOwner(login: "name1", avatarUrl: ""),
                                                     pageUrl: "", description: "", stars: 1)]
        localServiceMock.repositories = [Repository(name: "cached", owner: RepoOwner(login: "name1", avatarUrl: ""),
                                                    pageUrl: "", description: "", stars: 1)]
        interactor.fetchRepositories(searchText: "")
        XCTAssert(outputMock.didCallRepositoryFetched)
        XCTAssert(outputMock.repositories == localServiceMock.repositories)
    }
    
    func testEmptySearchNoCache() {
        interactor.fetchRepositories(searchText: "")
        XCTAssert(outputMock.didCallFetchFailed)
    }
    
}
