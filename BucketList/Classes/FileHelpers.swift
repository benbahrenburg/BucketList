//
//  BucketList - Just another cache provider with security built in
//  FileHelpers.swift
//
//  Created by Ben Bahrenburg on 3/23/16.
//  Copyright © 2016 bencoding.com. All rights reserved.
//

import Foundation

/**
 
 Internal File Helpers
 
 */
internal struct FileHelpers {    
    static func removeAll(url: URL) throws {
        if exists(url: url) {
            let path = url.path
            let filePaths = try FileManager.default.contentsOfDirectory(atPath: path)
            for filePath in filePaths {
                let filePath = String(format:"%@/%@", path, filePath)
                try remove(path: filePath)
            }
        }
    }
    
    static func exists(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func exists(url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    static func remove(url: URL) throws {
        if exists(url: url) {
            try FileManager.default.removeItem(atPath: url.path)
        }
    }
    
    static func remove(path: String) throws {
        if exists(path: path) {
            try FileManager.default.removeItem(atPath: path)
        }
    }
}
