//
//  BucketList - Just another cache provider with security built in
//  EncryptedDiskCache.swift
//
//  Created by Ben Bahrenburg on 3/23/16.
//  Copyright © 2016 bencoding.com. All rights reserved.
//

import Foundation
import RNCryptor

/**
 
 Encrypted File Based Cache Provider
 
 */

public final class EncryptedDiskCache: SecureBucket {
    
    fileprivate let _cacheName: String
    fileprivate let _directoryURL: URL
    
    var emptyOnUnload: Bool = true
    
    var imageConverterOption: CacheOptions.imageConverter = .imageIO
    
    public init(cacheName: String = UUID().uuidString) {
        _cacheName = cacheName
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        _directoryURL = dir.appendingPathComponent(_cacheName)
        
        if !FileHelpers.exists(url: _directoryURL) {
            do {
                try FileManager.default.createDirectory(atPath: _directoryURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Cannot create cache director: \(error)")
            }
        }
    }
    
    deinit {
        if emptyOnUnload {
            empty()
        }
    }
    
    @discardableResult public func add(secret: String, forKey: String, object: AnyObject) throws -> Bool {
        return try autoreleasepool { () -> Bool in
            let fileURL = getPathForKey(forKey: forKey)
            let data = NSKeyedArchiver.archivedData(withRootObject: object)
            try writeEncrypted(secret: secret, path: fileURL, data: data)
            return true
        }
    }
    
    @discardableResult public func add(secret: String, forKey: String, image: UIImage) throws -> Bool {
        return try autoreleasepool { () -> Bool in
            let fileURL = getPathForKey(forKey: forKey)
            if let data = Converters.convertImage(image: image, option: imageConverterOption) {
                try writeEncrypted(secret: secret, path: fileURL, data: data)
                return true
            }
            return false
        }
    }
    
    @discardableResult public func add(secret: String, forKey: String, data: Data) throws -> Bool {
        return try autoreleasepool { () -> Bool in
            let fileURL = getPathForKey(forKey: forKey)
            try writeEncrypted(secret: secret, path: fileURL, data: data)
            return true
        }
    }
    
    public func getObject(secret: String, forKey: String) throws -> AnyObject? {
        if exists(forKey: forKey) {
            let fileURL = getPathForKey(forKey: forKey)
            let data = try readEncrypted(secret: secret, path: fileURL)
            return NSKeyedUnarchiver.unarchiveObject(with: data) as AnyObject?
        }
        return nil
    }
    
    public func getData(secret: String, forKey: String) throws -> Data? {
        if exists(forKey: forKey) {
            let fileURL = getPathForKey(forKey: forKey)
            return try readEncrypted(secret: secret, path: fileURL)
        }
        return nil
    }
    
    public func getImage(secret: String, forKey: String) throws -> UIImage? {
        if exists(forKey: forKey) {
            let fileURL = getPathForKey(forKey: forKey)
            let data = try readEncrypted(secret: secret, path: fileURL)
            return UIImage(data: data)
        }
        return nil
    }
    
    @discardableResult public func remove(forKey: String) throws -> Bool {
        let fileURL = getPathForKey(forKey: forKey)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(atPath: fileURL.path)
        }
        return true
    }
    
    @discardableResult public func empty() -> Bool {
        do {
            try FileHelpers.removeAll(url: _directoryURL)
            return true
        } catch {
            print("Could not remove all cache: \(error)")
            return false
        }
    }
    
    public func exists(forKey: String) -> Bool {
        return FileHelpers.exists(url: getPathForKey(forKey: forKey))
    }
    
    fileprivate func getPathForKey(forKey: String) -> URL {
        return _directoryURL.appendingPathComponent(forKey)
    }
    
    fileprivate func readEncrypted(secret: String, path: URL) throws -> Data {
        return try autoreleasepool { () -> Data in
            let output = NSMutableData()
            let data = try Data(contentsOf: path)
            let decryptor = RNCryptor.Decryptor(password: secret)
            try output.append(decryptor.update(withData: data))
            try output.append(decryptor.finalData())
            return output as Data
        }
    }
    
    fileprivate func writeEncrypted(secret: String, path: URL, data: Data) throws {
        try autoreleasepool {
            let encryptor = RNCryptor.Encryptor(password: secret)
            let encrypt = NSMutableData()
            encrypt.append(encryptor.update(withData: data))
            encrypt.append(encryptor.finalData())
            try encrypt.write(to: path, options: [.atomicWrite, .completeFileProtection])
        }
    }
}
