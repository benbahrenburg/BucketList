//
//  BucketList - Just another cache provider with security built in
//  CacheOptions.swift
//
//  Created by Ben Bahrenburg on 3/23/16.
//  Copyright © 2016 bencoding.com. All rights reserved.
//
import Foundation

/**
 
 Caching Options
 
 */
public struct CacheOptions {
    
    /**
     
     Options to convert UIImage to Data
     
     */
    enum imageConverter {
        case imageIO
        case jpegRepresentation
    }
}
