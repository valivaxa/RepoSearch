//
//  NetworkService.swift
//  RepoSearch
//
//  Created by valivaxa on 2/9/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation

final class NetworkService {
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private let successCodes: Range<Int> = 200..<299
    private let failureCodes: Range<Int> = 400..<499
    
    func request(for url: URL, method: HTTPMethod,
                 params: Data? = nil,
                 headers: [String: String]? = nil,
                 success: ((Data?) -> Void)? = nil,
                 failure: ((_ data: Data?, _ error: Error?, _ responseCode: Int) -> Void)? = nil) {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = params
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        
        task = session.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                failure?(data, error, (error as NSError?)?.code ?? 0)
                return
            }
            
            if let error = error {
                failure?(data, error, httpResponse.statusCode)
                return
            }
            
            switch httpResponse.statusCode {
            case self.successCodes:
                success?(data)
            case self.failureCodes:
                failure?(data, error, httpResponse.statusCode)
            default:
                let info = [
                    NSLocalizedDescriptionKey: "Request failed with code \(httpResponse.statusCode)",
                    NSLocalizedFailureReasonErrorKey: "Wrong handling logic, wrong endpoing mapping or backend bug."
                ]
                let error = NSError(domain: "NetworkService", code: 0, userInfo: info)
                failure?(data, error, httpResponse.statusCode)
            }
        }
        
        task?.resume()
    }
}

