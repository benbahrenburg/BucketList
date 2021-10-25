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
    
    private let _cacheName: String
    private let _directoryURL: URL
    
    var emptyOnUnload: Bool = true
    var imageConverterOption: CacheOptions.imageConverter = CacheOptions.imageConverter.jpegRepresentation
    
    public init(_ cacheName: String = UUID().uuidString) {
        _cacheName = cacheName
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        _directoryURL = dir.appendingPathComponent(_cacheName)
        
        if !FileHelpers.exists(_directoryURL) {
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
    
    @discardableResult public func add(_ secret: String, forKey: String, object: AnyObject) throws -> Bool {
        return try autoreleasepool { () -> Bool in
            let fileURL = getPathForKey(forKey)
            guard let data: Data = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: true) else {
                return false
            }
            try writeEncrypted(secret, path: fileURL, data: data)
            return true
        }
    }
    
    @discardableResult public func add(_ secret: String, forKey: String, image: UIImage) throws -> Bool {
        return try autoreleasepool { () -> Bool in
            let fileURL = getPathForKey(forKey)
            if let data = Converters.convertImage(image, option: imageConverterOption) {
                try writeEncrypted(secret, path: fileURL, data: data)
                return true
            }
            return false
        }
    }
    
    @discardableResult public func add(_ secret: String, forKey: String, data: Data) throws -> Bool {
        return try autoreleasepool { () -> Bool in
            let fileURL = getPathForKey(forKey)
            try writeEncrypted(secret, path: fileURL, data: data)
            return true
        }
    }
    
    public func getObject(_ secret: String, forKey: String) throws -> AnyObject? {
        if exists(forKey) {
            let fileURL = getPathForKey(forKey)
            let data = try readEncrypted(secret, path: fileURL)
            if let obj = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as AnyObject? {
                return obj
            }
        }
        return nil
    }
    
    public func getData(_ secret: String, forKey: String) throws -> Data? {
        if exists(forKey) {
            let fileURL = getPathForKey(forKey)
            return try readEncrypted(secret, path: fileURL)
        }
        return nil
    }
    
    public func getImage(_ secret: String, forKey: String) throws -> UIImage? {
        if exists(forKey) {
            let fileURL = getPathForKey(forKey)
            let data = try readEncrypted(secret, path: fileURL)
            return UIImage(data: data)
        }
        return nil
    }
    
    @discardableResult public func remove(_ forKey: String) throws -> Bool {
        let fileURL = getPathForKey(forKey)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(atPath: fileURL.path)
        }
        return true
    }
    
    @discardableResult public func empty() -> Bool {
        do {
            try FileHelpers.removeAll(_directoryURL)
            return true
        } catch {
            print("Could not remove all cache: \(error)")
            return false
        }
    }
    
    public func exists(_ forKey: String) -> Bool {
        return FileHelpers.exists(getPathForKey(forKey))
    }
    
    private func getPathForKey(_ forKey: String) -> URL {
        return _directoryURL.appendingPathComponent(forKey)
    }
    
    private func readEncrypted(_ secret: String, path: URL) throws -> Data {
        return try autoreleasepool { () -> Data in
            let output = NSMutableData()
            let data = try Data(contentsOf: path)
            let decryptor = RNCryptor.Decryptor(password: secret)
            try output.append(decryptor.update(withData: data))
            try output.append(decryptor.finalData())
            return output as Data
        }
    }
    
    private func writeEncrypted(_ secret: String, path: URL, data: Data) throws {
        try autoreleasepool {
            let encryptor = RNCryptor.Encryptor(password: secret)
            let encrypt = NSMutableData()
            encrypt.append(encryptor.update(withData: data))
            encrypt.append(encryptor.finalData())
            try encrypt.write(to: path, options: [.atomicWrite, .completeFileProtection])
        }
    }
}
