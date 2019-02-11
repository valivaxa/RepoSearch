//
//  RepoDetailsContract.swift
//  RepoSearch
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

protocol RepoDetailsView: AnyObject {
    func displayPage(with url: URL)
}

protocol RepoDetailsViewOutput: AnyObject {
    func viewDidLoad()
    func didTriggerDismiss()
}

protocol RepoDetailsRouterInput: AnyObject {
    func dismiss()
}
