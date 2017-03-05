//
//  BucketList - Just another cache provider with security built in
//  SecureBucket.swift
//
//  Created by Ben Bahrenburg on 3/23/16.
//  Copyright © 2016 bencoding.com. All rights reserved.
//

/**
 
 Protocol used by all Bucket Cache Providers that require secrets
 
 */
public protocol SecureBucket {
    /**
     Adds an AnyObject to secure cache provider
     
     - Parameter secret: The password used to encrypt the object
     - Parameter forKey: The cache key for the cached AnyObject
     - Parameter object: The object to be cached
     - Returns: True if the object was successfully added to cache
     */
    @discardableResult func add(secret: String, forKey: String, object: AnyObject) throws -> Bool
    /**
     Adds a UIImage to secure cache provider
     
     - Parameter secret: The password used to encrypt the object
     - Parameter forKey: The cache key for the cached image
     - Parameter image: The image to be cached
     - Returns: True if the image was successfully added to cache
     */
    @discardableResult func add(secret: String, forKey: String, image: UIImage) throws -> Bool
    /**
     Adds Data to secure cache provider
     
     - Parameter secret: The password used to encrypt the object
     - Parameter forKey: The cache key for the cached data
     - Parameter data: The data to be cached
     - Returns: True if the data was successfully added to cache
     */
    @discardableResult func add(secret: String, forKey: String, data: Data) throws -> Bool
    /**
     Returns AnyObject? (optional) for a provided key. Nil is returned if no cache value is found.
     
     - Parameter secret: The password used to encrypt the object
     - Parameter forKey: The cache key for the cached AnyObject
     - Returns: AnyObject? (optional) for the provided cache key
     */
    func getObject(secret: String, forKey: String) throws -> AnyObject?
    /**
     Returns Data? (optional) for a provided key. Nil is returned if no cache value is found.
     
     - Parameter secret: The password used to encrypt the data
     - Parameter forKey: The cache key for the cached Data
     - Returns: Data? (optional) for the provided cache key
     */
    func getData(secret: String, forKey: String) throws -> Data?
    /**
     Returns UIImage? (optional) for a provided key. Nil is returned if no cache value is found.
     
     - Parameter secret: The password used to encrypt the data
     - Parameter forKey: The cache key for the cached UIImage
     - Returns: UIImage? (optional) for the provided cache key
     */
    func getImage(secret: String, forKey: String) throws -> UIImage?
    /**
     Removes item from cached.
     
     - Parameter forKey: The cache key for the cached UIImage
     - Returns: True if the cached value is successfully removed
     */
    @discardableResult func remove(forKey: String) throws -> Bool
    /**
     Removes all values from cache
     
     - Parameter forKey: The cache key for the cached UIImage
     - Returns: True if the all cached values is successfully removed
     */
    @discardableResult func empty() -> Bool
    /**
     Returns True if a Cache key exists
     
     - Parameter forKey: The key to check if a cached value exists
     - Returns: True if a cached value exists
     */
    func exists(forKey: String) -> Bool
}
