//
//  BucketList - Just another cache provider with security built in
//  Converters.swift
//
//  Created by Ben Bahrenburg on 3/23/16.
//  Copyright © 2016 bencoding.com. All rights reserved.
//


import Foundation
import ImageIO
import MobileCoreServices

/**
 
 Internal Helper functions to convert formats
 
 */
internal struct Converters {
    static func UIImageJPEGRepresentation2(image: UIImage, compression: CGFloat) -> Data? {
        return autoreleasepool(invoking: { () -> Data? in
            return UIImageJPEGRepresentation(image, compression)
        })
    }
    
    static func convertImage(image: UIImage, option: CacheOptions.imageConverter) -> Data? {
        if option == .imageIO {
            return UIImageToDataIO(image: image)
        }
        return UIImageJPEGRepresentation2(image: image, compression: 0.9)
    }
    
    fileprivate static func UIImageToDataIO(image: UIImage) -> Data? {
        return autoreleasepool(invoking: { () -> Data in
            let data = NSMutableData()
            let options: NSDictionary = [
                kCGImagePropertyOrientation: 1, // Top left
                kCGImagePropertyHasAlpha: true,
                kCGImageDestinationLossyCompressionQuality: 1.0
            ]
            
            let imageDestinationRef = CGImageDestinationCreateWithData(data as CFMutableData, kUTTypeJPEG, 1, nil)!
            CGImageDestinationAddImage(imageDestinationRef, image.cgImage!, options)
            CGImageDestinationFinalize(imageDestinationRef)
            
            return data as Data
        })
    }
}
