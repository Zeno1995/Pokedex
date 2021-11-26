//
//  ImageCache.swift
//  Pokedex
//
//  Created by Enzo Corsiero on 26/11/21.
//

import Foundation
import UIKit

class MemoryImageCache: ImageCacheType {

    lazy var memoryCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 10000000 // approx 10 mb
        cache.countLimit = 30
        return cache
    }()

    func image(for url: String, completion: @escaping (UIImage?) -> Void) {
        let image = memoryCache.object(forKey: url as NSString)
        completion(image)
    }

    func insert(_ image: UIImage, forUrl url: String, withTTL ttl: UInt) {
        memoryCache.setObject(image, forKey: url as NSString, cost: Self.cost(for: image))
    }

    func insert(_ image: UIImage, forUrl url: String) {
        memoryCache.setObject(image, forKey: url as NSString)
    }
    static func cost(for image: UIImage) -> Int {
        Int(image.size.width * image.size.height * 4 * image.scale)
    }
}

class StoredImageCache: NetworkCache {

    private func saveImageFile(_ image: UIImage, forUrl url: String, withTTL ttl: UInt? = nil) {
        do {
            if let data = image.jpeg(.medium) {
                self.setObject(data, forKey: url, withTTL: ttl)
            }
        }
    }

    private func getImageFile(url: String, completion: @escaping (UIImage?) -> Void) {
        if let data = self.object(forKey: url), let image = UIImage(data: data) {
            completion(image)
        } else {
            completion(nil)
        }
    }
}

extension StoredImageCache: ImageCacheType {
    func image(for url: String, completion: @escaping (UIImage?) -> Void) {
        self.getImageFile(url: url, completion: completion)
    }

    func insert(_ image: UIImage, forUrl url: String, withTTL ttl: UInt) {
        self.saveImageFile(image, forUrl: url, withTTL: ttl)
    }

    func insert(_ image: UIImage, forUrl url: String) {
        self.saveImageFile(image, forUrl: url, withTTL: 86400) // 24 ore
    }
}

class ImageCache: ImageCacheType {
    let memoryCache = MemoryImageCache()
    let storedCache = StoredImageCache()

    func image(for url: String, completion: @escaping (UIImage?) -> Void) {
        memoryCache.image(for: url) { [weak self] (image) in
            guard let self = self else { return }
            if let img = image {
                completion(img)
            } else {
                self.storedCache.image(for: url) { (image) in
                    if let img = image {
                        completion(image)
                        self.memoryCache.insert(img, forUrl: url)
                    } else {
                        completion(image)
                    }
                }
            }
        }
    }

    func insert(_ image: UIImage, forUrl url: String, withTTL ttl: UInt) {
        self.storedCache.insert(image, forUrl: url, withTTL: ttl)
        self.memoryCache.insert(image, forUrl: url)
    }

    func insert(_ image: UIImage, forUrl url: String) {
        self.storedCache.insert(image, forUrl: url)
        self.memoryCache.insert(image, forUrl: url)
    }

}

protocol ImageCacheType: AnyObject {
    func image(for url: String, completion: @escaping (UIImage?) -> Void)
    func insert(_ image: UIImage, forUrl url: String, withTTL ttl: UInt)
    func insert(_ image: UIImage, forUrl url: String)
}
