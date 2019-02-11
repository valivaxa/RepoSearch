//
//  RootRouter.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import UIKit

final class RootRouter {
    static func showRootScreen(in window: UIWindow) {
        window.makeKeyAndVisible()
        window.rootViewController = RepoListRouter.setupModule()
    }
}
