//
//  BucketList - Just another cache provider with security built in
//  MemoryCache.swift
//
//  Created by Ben Bahrenburg on 3/23/16.
//  Copyright © 2016 bencoding.com. All rights reserved.
//

import Foundation

/**
 
 Caching provider based on NSCache
 
 */
public class MemoryCache: Bucket {
    
    private var cache: NSCache =  NSCache<NSString, AnyObject>()

    public init() {}
    
    deinit {
        cache.removeAllObjects()
    }
    
    @discardableResult public func add(_ forKey: String, object: AnyObject) -> Bool {
        cache.setObject(object, forKey: forKey as NSString)
        return true
    }
    
    @discardableResult public func add(_ forKey: String, image: UIImage) -> Bool {
        cache.setObject(image, forKey: forKey as NSString)
        return true
    }
    
    @discardableResult public func add(_ forKey: String, data: Data) -> Bool {
        cache.setObject(data as AnyObject, forKey: forKey as NSString)
        return true
    }
    
    public func getObject(_ forKey: String) -> AnyObject? {
        if exists(forKey) {
            return cache.object(forKey: forKey as NSString)
        }
        return nil
    }
    
    public func getData(_ forKey: String) -> Data? {
        if exists(forKey) {
            if let obj = getObject(forKey) {
                return obj as? Data
            }
            
        }
        return nil
    }
    
    public func getImage(_ forKey: String) -> UIImage? {
        if exists(forKey) {
            if let obj = getObject(forKey) {
                return UIImage(data: obj as! Data)
            }
            
        }
        return nil
    }
    
    @discardableResult public func remove(_ forKey: String) -> Bool {
        cache.removeObject(forKey: forKey as NSString)
        return true
    }
    
    @discardableResult public func empty() -> Bool {
        cache.removeAllObjects()
        return true
    }
    
    public func exists(_ forKey: String) -> Bool {
        if let _ = cache.object(forKey: forKey as NSString) {
            return true
        }
        return false
    }
    
}
