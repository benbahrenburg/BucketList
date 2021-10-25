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
    static func removeAll(_ url: URL) throws {
        if exists(url) {
            let path = url.path
            let filePaths = try FileManager.default.contentsOfDirectory(atPath: path)
            for filePath in filePaths {
                let filePath = String(format:"%@/%@", path, filePath)
                try remove(filePath)
            }
        }
    }
    
    static func exists(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func exists(_ url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    static func remove(_ url: URL) throws {
        if exists(url) {
            try FileManager.default.removeItem(atPath: url.path)
        }
    }
    
    static func remove(_ path: String) throws {
        if exists(path) {
            try FileManager.default.removeItem(atPath: path)
        }
    }
}
