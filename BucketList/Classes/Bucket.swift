//
//  Bucket.swift
//  Pods
//
//  Created by Ben Bahrenburg on 3/4/17.
//
//

public protocol Bucket {
    @discardableResult func add(forKey: String, object: AnyObject) -> Bool
    @discardableResult func add(forKey: String, image: UIImage) throws -> Bool
    @discardableResult func add(forKey: String, data: Data) throws -> Bool
    func getObject(forKey: String) -> AnyObject?
    func getData(forKey: String) -> Data?
    func getImage(forKey: String) -> UIImage?
    @discardableResult func remove(forKey: String) throws -> Bool
    @discardableResult func empty() -> Bool
    func exists(forKey: String) -> Bool
}
