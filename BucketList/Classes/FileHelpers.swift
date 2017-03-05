//
//  FileHelpers.swift
//  Pods
//
//  Created by Ben Bahrenburg on 3/4/17.
//
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
