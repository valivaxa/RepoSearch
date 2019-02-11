//
//  IndicatableView.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

protocol IndicatableView: AnyObject {
    func showActivityIndicator()
    func hideActivityIndicator()
}
