//
//  EncryptedDiskCache.swift
//  Pods
//
//  Created by Ben Bahrenburg on 3/4/17.
//
//

import Foundation
import RNCryptor
import ImageIO
import MobileCoreServices

public final class EncryptedDiskCache: SecureBucket {
    
    fileprivate let _cacheName: String
    fileprivate let _directoryURL: URL
    
    enum imageConverter {
        case imageIO
        case jpegRepresentation
        
    }
    
    var emptyOnUnload: Bool = true
    
    var imageConverterOption: imageConverter = .imageIO
    
    public init(cacheName: String) {
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
    
    @discardableResult public func add(secret: String, forKey: String, object: AnyObject) -> Bool {
        return autoreleasepool { () -> Bool in
            let fileURL = getPathForKey(forKey: forKey)
            NSKeyedArchiver.archiveRootObject(object, toFile: fileURL.path)
            return true
        }
    }
    
    @discardableResult public func add(secret: String, forKey: String, image: UIImage) throws -> Bool {
        return try autoreleasepool { () -> Bool in
            let fileURL = getPathForKey(forKey: forKey)
            if let data = convertImage(image: image) {
                try writeEncrypted(secret: secret, path: fileURL, data: data)
            }
            return true
        }
    }
    
    @discardableResult public func add(secret: String, forKey: String, data: Data) throws -> Bool {
        return try autoreleasepool { () -> Bool in
            let fileURL = getPathForKey(forKey: forKey)
            try writeEncrypted(secret: secret, path: fileURL, data: data)
            return true
        }
    }
    
    public func getObject(secret: String, forKey: String) -> AnyObject? {
        if exists(forKey: forKey) {
            let fileURL = getPathForKey(forKey: forKey)
            return NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as AnyObject?
        }
        return nil
    }
    
    public func getData(secret: String, forKey: String) -> Data? {
        if exists(forKey: forKey) {
            let fileURL = getPathForKey(forKey: forKey)
            do {
                return try readEncrypted(secret: secret, path: fileURL)
            } catch {
                print("Could not load from cache: \(error)")
                return nil
            }
        }
        return nil
    }
    
    public func getImage(secret: String, forKey: String) -> UIImage? {
        if exists(forKey: forKey) {
            let fileURL = getPathForKey(forKey: forKey)
            do {
                let data = try readEncrypted(secret: secret, path: fileURL)
                return UIImage(data: data)
            } catch {
                print("Could not load from cache: \(error)")
                return nil
            }
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
    
    fileprivate func convertImage(image: UIImage) -> Data? {
        if imageConverterOption == .imageIO {
            return UIImageToDataIO(image: image)
        }
        return UIImageJPEGRepresentation(image, 1)
    }
    
    fileprivate func UIImageToDataIO(image: UIImage) -> Data? {
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

fileprivate struct FileHelpers {
    
    static func removeAll(url: URL) throws {
        if exists(url: url) {
            let path = url.path
            let filePaths = try FileManager.default.contentsOfDirectory(atPath: path)
            for filePath in filePaths {
                let filePath = String(format:"%@/%@", path, filePath)
                try remove(path: filePath)
            }
        }
    }
    
    static func exists(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func exists(url: URL) -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    static func remove(url: URL) throws {
        if exists(url: url) {
            try FileManager.default.removeItem(atPath: url.path)
        }
    }
    
    static func remove(path: String) throws {
        if exists(path: path) {
            try FileManager.default.removeItem(atPath: path)
        }
    }
}
