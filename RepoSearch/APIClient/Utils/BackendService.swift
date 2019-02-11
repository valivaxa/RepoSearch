//
//  BackendService.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

final class BackendService {
    
    private let networkService = NetworkService()
    private let baseURL = "https://api.github.com"
    
    func request<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<T.Response>) {
        var urlComponents = URLComponents(
            url: URL(string: baseURL)!.appendingPathComponent(request.endpoint),
            resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = request.queryItems
        let method = request.method
        let params = request.parametersData
        let header = request.header
        
        networkService.request(for: urlComponents.url!, method: method, params: params, headers: header, success: { (data) in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(ResponseError.decoding))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let responseData = try decoder.decode(T.Response.self, from: data)
                    completion(.success(responseData))
                }
                catch(let error) {
                    completion(.failure(error))
                }
            }
        }) { (data, error, statusCode) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(ResponseError.decoding))
                }
            }
        }
    }
}
