//
//  MemoryCache.swift
//  Pods
//
//  Created by Ben Bahrenburg on 3/4/17.
//
//

import Foundation

public class MemoryCache: Bucket {
    
    fileprivate var cache: NSCache =  NSCache<NSString, AnyObject>()
    
    @discardableResult public func add(forKey: String, object: AnyObject) -> Bool {
        cache.setObject(object, forKey: forKey as NSString)
        return true
    }
    
    @discardableResult public func add(forKey: String, image: UIImage) -> Bool {
        cache.setObject(image, forKey: forKey as NSString)
        return true
    }
    
    @discardableResult public func add(forKey: String, data: Data) -> Bool {
        cache.setObject(data as AnyObject, forKey: forKey as NSString)
        return true
    }
    
    public func getObject(forKey: String) -> AnyObject? {
        if exists(forKey: forKey) {
            return cache.object(forKey: forKey as NSString)
        }
        return nil
    }
    
    public func getData(forKey: String) -> Data? {
        if exists(forKey: forKey) {
            if let obj = getObject(forKey: forKey) {
                return obj as? Data
            }
            
        }
        return nil
    }
    
    public func getImage(forKey: String) -> UIImage? {
        if exists(forKey: forKey) {
            if let obj = getObject(forKey: forKey) {
                return UIImage(data: obj as! Data)
            }
            
        }
        return nil
    }
    
    @discardableResult public func remove(forKey: String) -> Bool {
        cache.removeObject(forKey: forKey as NSString)
        return true
    }
    
    @discardableResult public func empty() -> Bool {
        cache.removeAllObjects()
        return true
    }
    
    public func exists(forKey: String) -> Bool {
        if let _ = getObject(forKey: forKey) {
            return true
        }
        return false
    }
    
}
