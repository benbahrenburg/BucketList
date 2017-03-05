//
//  Converters.swift
//  Pods
//
//  Created by Ben Bahrenburg on 3/4/17.
//
//

import Foundation
import ImageIO
import MobileCoreServices

/**
 
 Internal Helper functions to convert formats
 
 */
internal struct Converters {
    static func convertImage(image: UIImage, option: CacheOptions.imageConverter) -> Data? {
        if option == .imageIO {
            return UIImageToDataIO(image: image)
        }
        return UIImageJPEGRepresentation(image, 1)
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
