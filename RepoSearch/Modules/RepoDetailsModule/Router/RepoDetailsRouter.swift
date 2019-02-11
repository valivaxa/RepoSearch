//
//  RepoDetailsRouter.swift
//  RepoSearch
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import UIKit

final class RepoDetailsRouter {
    weak var view: UIViewController?
    
    static func setupModule(with repository: Repository) -> UIViewController {
        let view = RepoDetailsViewController()
        let router = RepoDetailsRouter()
        let presenter = RepoDetailsPresenter(router: router)
        
        view.presenter = presenter
        presenter.view = view
        router.view = view
        
        presenter.repository = repository

        return UINavigationController(rootViewController: view)
    }
}

extension RepoDetailsRouter: RepoDetailsRouterInput {
    func dismiss() {
        view?.dismiss(animated: true, completion: nil)
    }
}
