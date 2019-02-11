//
//  RepoListRouter.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import UIKit

final class RepoListRouter {
    weak var view: UIViewController?
    
    static func setupModule() -> UIViewController {
        guard let view = UIStoryboard(name: Storyboard.repoList, bundle: nil)
            .instantiateViewController(withIdentifier: RepoListViewController.storyboardID) as? RepoListViewController else {
            fatalError("Unrecognized RepoListViewController identifier")
        }
        let remoteRepoService = RemoteRepoService()
        let cacheService = CachedRepoService()
        let interactor = RepoListInteractor(remoteService: remoteRepoService, localService: cacheService)
        let router = RepoListRouter()
        let presenter = RepoListPresenter(interactor: interactor, router: router)

        view.presenter = presenter
        presenter.view = view
        interactor.output = presenter
        router.view = view
        
        return UINavigationController(rootViewController: view)
    }
}

extension RepoListRouter: RepoListRouterInput {
    func showDetails(for repository: Repository) {
        let detailsScreen = RepoDetailsRouter.setupModule(with: repository)
        self.view?.present(detailsScreen, animated: true, completion: nil)
    }
}
