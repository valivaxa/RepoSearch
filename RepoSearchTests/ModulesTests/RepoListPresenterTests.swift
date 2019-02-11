//
//  RepoListPresenterTests.swift
//  RepoSearchTests
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import XCTest
@testable import RepoSearch

class RepoListPresenterTests: XCTestCase {

    var presenter: RepoListPresenter!
    var interactorMock: RepoListInteractorMock!
    var routerMock: RepoListRouterMock!
    var viewMock: RepoListViewMock!
    
    let repositories = [Repository(name: "test1", owner: RepoOwner(login: "name1", avatarUrl: ""),
                                   pageUrl: "", description: "", stars: 1),
                        Repository(name: "test2", owner: RepoOwner(login: "name2", avatarUrl: ""),
                                   pageUrl: "", description: "", stars: 1)]
    
    override func setUp() {
        self.interactorMock = RepoListInteractorMock()
        self.routerMock = RepoListRouterMock()
        self.viewMock = RepoListViewMock()
        
        self.presenter = RepoListPresenter(interactor: interactorMock, router: routerMock)
        self.presenter.view = viewMock
    }
    
    func testInitialPresentation() {
        presenter.viewDidLoad()
        XCTAssert(viewMock.didCallShowActivityIndicator)
        XCTAssert(interactorMock.didCallFetchRepositories)
    }
    
    func testRepositoriesRefreshed() {
        presenter.repositoriesFetched(repositories, shouldRefresh: true)
        XCTAssert(viewMock.didCallHideActivityIndicator)
        XCTAssert(viewMock.didCallSetRepositories)
        XCTAssert(presenter.repositories.count == repositories.count)
    }
    
    func testRepositoriesAppend() {
        presenter.repositories = self.repositories
        let initialRepoCount = presenter.repositories.count
        presenter.repositoriesFetched(repositories, shouldRefresh: false)
        XCTAssert(viewMock.didCallAppendRepositories)
        XCTAssert(presenter.repositories.count == initialRepoCount + repositories.count)
    }
    
    func testOnScrollLoading() {
        presenter.repositories = self.repositories
        let lastRowIndex = presenter.repositories.count - 1
        presenter.didScrollToIndex(lastRowIndex)
        XCTAssert(interactorMock.didCallFetchMore)
    }
    
    func testFetchFailed() {
        presenter.fetchFailed(with: "error")
        XCTAssert(viewMock.didCallHideActivityIndicator)
        XCTAssert(viewMock.didCallDisplayEmptyResults)
    }
    
    func testThrottledSearch() {
        let expectation = XCTestExpectation(description: "Search text sent with delay.")
        presenter.didChangeSearchText("text1")
        XCTAssert(viewMock.didCallShowActivityIndicator)
        XCTAssertFalse(interactorMock.didCallFetchRepositories, "must delay search input")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssert(self.interactorMock.didCallFetchRepositories)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testRepositorySelected() {
        presenter.repositories = repositories
        let expectedRepository = presenter.repositories.first
        presenter.didSelectRepository(at: 0)
        XCTAssert(routerMock.didCallShowDetails)
        XCTAssert(routerMock.repository != nil)
        XCTAssert(routerMock.repository == expectedRepository)
    }
}

extension Repository: Equatable {
    public static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description &&
            lhs.pageUrl == rhs.pageUrl
    }
}
