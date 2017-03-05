//
//  CacheOptions.swift
//  Pods
//
//  Created by Ben Bahrenburg on 3/4/17.
//
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
