//
//  Result.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

typealias ResultCallback<T> = (Result<T>) -> Void

enum Result<T> {
    case success(T)
    case failure(Error)
}
