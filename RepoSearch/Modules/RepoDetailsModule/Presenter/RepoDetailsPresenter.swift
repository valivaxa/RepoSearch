//
//  RepoDetailsPresenter.swift
//  RepoSearch
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

final class RepoDetailsPresenter {
    weak var view: RepoDetailsView?
    private let router: RepoDetailsRouterInput
    
    var repository: Repository!
    
    init(router: RepoDetailsRouterInput) {
        self.router = router
    }
}

extension RepoDetailsPresenter: RepoDetailsViewOutput {
    func viewDidLoad() {
        if let url = URL(string: repository.pageUrl) {
            view?.displayPage(with: url)
        }
    }
    
    func didTriggerDismiss() {
        router.dismiss()
    }
}
