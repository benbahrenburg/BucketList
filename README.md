# BucketList

Need caching? Focused on security? BucketList makes working with encrypted caching easy. Also supports stand your standard key value caching as well.

## Features

* Encrypted Disk Caching
* In Memory Caching
* Encrypted In Memory Caching  [feature in process]


## Requirements

* Xcode 8.2 or newer
* Swift 3.0
* iOS 10 or greater

## Installation

LockedBucket is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:


```ruby
pod "BucketList"
```

__Carthage__

```
github "benbahrenburg/BucketList"
```

__Manually__

Copy all `*.swift` files contained in `BucketList/Classes/` directory into your project. 

## Usage

There are six main classes in BucketList:

1. SecureBucket - The protocol all secure cache providers must conform 
2. Bucket - The protocol all non secure cache providers must conform
3. EncryptedDiskCache - This Cache provider encrypts all objects you place into cache and persists the values to disk.
4. EncryptedMemoryCache - This Cache provider encrypts all objects you place into cache and stores the encrypted items in an NSCache collection.
5. MemoryCache -  Your standard NSCache backed Caching 
6. DictionaryCache - An old school approach to caching using NSMutableDictionary 

## Examples

All of the Caching providers have a similar API, with the only difference being the secret field used in the secure protocols.


### Saving items to cache

BucketList makes it easy to save items into cache.  Below is an example on how to do this using the EncryptedDiskCache.

```swift
//Let's create an instance of the EncryptedDiskCache provider
//The first things we need to do is create a caching name. This will be the folder the files are cached within.
let cache = EncryptedDiskCache(cacheName: "foo")

//Now let's add a image to cache
let myImage = .....
let result = cache.add(secret: "a password", forKey: "my-secret-image", image: myImage) 
print("Image was successfull added? \(result)")

//Now let's add a AnyObject to cache
let myObject = .....
let result = cache.add(secret: "a password", forKey: "my-secret-object", object: myObject) 
print("myObject was successfull added? \(result)")

//Now let's add a Data to cache
let myData = .....
let result = cache.add(secret: "a password", forKey: "my-secret-data", data: myData) 
print("myData was successfull added? \(result)")

```

### Getting items from cache

You can easily get items from cache.  Below is an example on how to do this using the EncryptedDiskCache. 

```swift
//Let's create an instance of the EncryptedDiskCache provider
//The first things we need to do is create a caching name. This will be the folder the files are cached within.
let cache = EncryptedDiskCache(cacheName: "foo")

//Let's get our image from cache
let myImage = cache.getImage(secret: "a password", forKey: "my-secret-image") 

//Now let's get our AnyObject from cache
let myObject = cache.getObject(secret: "a password", forKey: "my-secret-object") 
print("myObject was successfull added? \(result)")

//Now let's get our Data from cache
let myData = cache.getData(secret: "a password", forKey: "my-secret-data") 

```

### Checking if item in Cache

You can easily check if items are already in cache using the exist function.  Below is an example on how to do this using the EncryptedDiskCache.

```swift
//Let's create an instance of the EncryptedDiskCache provider
//The first things we need to do is create a caching name. This will be the folder the files are cached within.
let cache = EncryptedDiskCache(cacheName: "foo")

let isThere = cache.exists(forKey: "my-secret-image")
print("Is my image already in cache? \(isThere)")

```

### Removing Cache Items

You can also remove items from cache.  Below is an example on how to do this using the EncryptedDiskCache.

```swift
//Let's create an instance of the EncryptedDiskCache provider
//The first things we need to do is create a caching name. This will be the folder the files are cached within.
let cache = EncryptedDiskCache(cacheName: "foo")

let wasRemoved = cache.remove(forKey: "my-secret-image")
print("Is my image was removed from cache? \(wasRemoved)")

```

### Emptying Cache

You can empty all of your cache items easily.  Below is an example on how to do this using the EncryptedDiskCache.

```swift
//Let's create an instance of the EncryptedDiskCache provider
//The first things we need to do is create a caching name. This will be the folder the files are cached within.
let cache = EncryptedDiskCache(cacheName: "foo")

let allRemoved = cache.empty()
print("All items removed from cache? \(allRemoved)")

```
## Important Considerations

* Lifecycle: By default all of the cache providers empty their cache items on deinit.
* Durability: All of the providers use cache objects that can be drained by iOS if your app starts to run low on memory or diskspace. Don't assume a cache item will be there, always verify!!! 

## Dependencies

* All of the encrypted providers use [RNCryptor](https://github.com/RNCryptor/RNCryptor).


## Author

Ben Bahrenburg, [@bencoding](https://twitter.com/bencoding)

## License

LockedBucket is available under the MIT license. See the LICENSE file for more details.
