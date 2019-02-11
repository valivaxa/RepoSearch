//
//  RemoteRepoService.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

protocol RemoteRepoServiceProtocol: AnyObject {
    func getRepositories(query: RepoSearchQuery, sort: RepoSortParams, completion: @escaping ResultCallback<[Repository]>)
}

final class RemoteRepoService: RemoteRepoServiceProtocol {
    private let backendService = BackendService()
    
    func getRepositories(query: RepoSearchQuery, sort: RepoSortParams, completion: @escaping ResultCallback<[Repository]>) {
        let request = SearchReposRequest(query: query, sort: sort)
        backendService.request(request, completion: { result in
            switch result {
            case .success(let responseData):
                completion(.success(responseData.items))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
