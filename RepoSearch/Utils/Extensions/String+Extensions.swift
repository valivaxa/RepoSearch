//
//  String+Extensions.swift
//  RepoSearch
//
//  Created by valivaxa on 2/11/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

extension String {
    func trimmingToLength(_ length: Int) -> String {
        guard length < self.count else { return self }
        let endIndex = index(startIndex, offsetBy: length)
        return String(self[..<endIndex])
    }
}
