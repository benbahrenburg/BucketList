//
//  BucketList - Just another cache provider with security built in
//  EncryptedMemoryCache.swift
//
//  Created by Ben Bahrenburg on 3/23/16.
//  Copyright © 2016 bencoding.com. All rights reserved.
//

import Foundation
import RNCryptor
import ImageIO
import MobileCoreServices

/**
 
 Encrypted NSCache Based Cache Provider
 
 */
public final class EncryptedMemoryCache: SecureBucket {
    
    fileprivate var cache: NSCache =  NSCache<NSString, AnyObject>()
    
    var imageConverterOption: CacheOptions.imageConverter = .imageIO

    public init() {}
    
    deinit {
        cache.removeAllObjects()
    }
    
    @discardableResult public func add(secret: String, forKey: String, object: AnyObject) throws -> Bool {
        return autoreleasepool { () -> Bool in
            let data = NSKeyedArchiver.archivedData(withRootObject: object)
            let toStore = getEncryptedData(secret: secret, data: data)
            cache.setObject(toStore as AnyObject, forKey: forKey as NSString)
            return true
        }
    }
    
    @discardableResult public func add(secret: String, forKey: String, image: UIImage) throws -> Bool {
        return autoreleasepool { () -> Bool in
            if let data = Converters.convertImage(image: image, option: imageConverterOption) {
                let toStore = getEncryptedData(secret: secret, data: data)
                cache.setObject(toStore as AnyObject, forKey: forKey as NSString)
                return true
            }
            return false
        }
    }
    
    @discardableResult public func add(secret: String, forKey: String, data: Data) throws -> Bool {
        return autoreleasepool { () -> Bool in
            let toStore = getEncryptedData(secret: secret, data: data)
            cache.setObject(toStore as AnyObject, forKey: forKey as NSString)
            return true
        }
    }
    
    public func getObject(secret: String, forKey: String) throws -> AnyObject? {
        if let data = try getData(secret: secret, forKey: forKey) {
            return NSKeyedUnarchiver.unarchiveObject(with: data) as AnyObject?
        }
        return nil
    }
    
    public func getData(secret: String, forKey: String) throws -> Data? {
        if exists(forKey: forKey) {
            if let obj = cache.object(forKey: forKey as NSString) {
                return try readEncrypted(secret: secret, data: obj as! Data)
            }
        }
        return nil
    }
    
    public func getImage(secret: String, forKey: String) throws -> UIImage? {
        if let data = try getData(secret: secret, forKey: forKey) {
            return UIImage(data: data)
        }
        return nil
    }
    
    @discardableResult public func remove(forKey: String) throws -> Bool {
        cache.removeObject(forKey: forKey as NSString)
        return true
    }
    
    @discardableResult public func empty() -> Bool {
        cache.removeAllObjects()
        return true
    }
    
    public func exists(forKey: String) -> Bool {
        if let _ = cache.object(forKey: forKey as NSString) {
            return true
        }
        return false
    }
    
    fileprivate func readEncrypted(secret: String, data: Data) throws -> Data {
        return try autoreleasepool { () -> Data in
            let output = NSMutableData()
            let decryptor = RNCryptor.Decryptor(password: secret)
            try output.append(decryptor.update(withData: data))
            try output.append(decryptor.finalData())
            return output as Data
        }
    }
    
    fileprivate func getEncryptedData(secret: String, data: Data) -> Data {
        return autoreleasepool { () -> Data in
            let encryptor = RNCryptor.Encryptor(password: secret)
            let encrypt = NSMutableData()
            encrypt.append(encryptor.update(withData: data))
            encrypt.append(encryptor.finalData())
            return encrypt as Data
        }
    }
}
