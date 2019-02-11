//
//  JSONCacheService.swift
//  RepoSearch
//
//  Created by valivaxa on 2/10/19.
//  Copyright © 2019 valivaxa. All rights reserved.
//

import Foundation


final class JSONCacheService {
    
    static let shared = JSONCacheService()
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    private let isolationQueue = DispatchQueue(label: "com.valivaxa.repocache", attributes: .concurrent)
    private let fileManager = FileManager.default
    private let cachePath: URL
    
    private init() {
        let baseCachePath = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cachePath = baseCachePath.appendingPathComponent("com.valivaxa.RepoSearch")
        if !fileManager.fileExists(atPath: self.cachePath.path) {
            try? fileManager.createDirectory(at: self.cachePath, withIntermediateDirectories: false, attributes: nil)
        }
    }
}

extension JSONCacheService {
    func cacheData<T: Encodable>(_ data: T, fileName: String, overwriting: Bool = false) {
        let filePath = self.cachePath.appendingPathComponent(fileName).path
        guard let data = try? self.jsonEncoder.encode(data) else { return }
        isolationQueue.async(flags: .barrier) {
            if !self.fileManager.fileExists(atPath: filePath) || overwriting {
                self.fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
            } else {
                guard let fileWriter = FileHandle(forWritingAtPath: filePath) else { return }
                fileWriter.seekToEndOfFile()
                fileWriter.write(data)
                fileWriter.closeFile()
            }
        }
    }
    
    func getData<T: Decodable>(fileName: String) -> T? {
        let fileURL = cachePath.appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        
        var result: T?
        isolationQueue.sync {
            let fileReader = FileHandle(forReadingAtPath: fileURL.path)!
            let data = fileReader.readDataToEndOfFile()
            fileReader.closeFile()
            result = try? self.jsonDecoder.decode(T.self, from: data)
        }
        return result
    }
}
