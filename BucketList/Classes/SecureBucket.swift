

public protocol SecureBucket {
    @discardableResult func add(secret: String, forKey: String, object: AnyObject) -> Bool
    @discardableResult func add(secret: String, forKey: String, image: UIImage) throws -> Bool
    @discardableResult func add(secret: String, forKey: String, data: Data) throws -> Bool
    func getObject(secret: String, forKey: String) -> AnyObject?
    func getData(secret: String, forKey: String) -> Data?
    func getImage(secret: String, forKey: String) -> UIImage?
    @discardableResult func remove(forKey: String) throws -> Bool
    @discardableResult func empty() -> Bool
    func exists(forKey: String) -> Bool
}
