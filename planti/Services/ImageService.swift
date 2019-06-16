//
//  ImageCacheService.swift
//  planti
//
//  Created by Yan Zhan on 6/3/19.
//  Copyright © 2019 planti. All rights reserved.
//

import UIKit
import ImageSlideshow

class ImageService {
    private static let imageService = ImageService()
    private let imageCache: NSCache = NSCache<AnyObject, UIImage>()
    
    class func shared() -> ImageService {
        return imageService
    }
    
    public func fetchImage(urlString: String, defaultImage: UIImage, completion: @escaping (UIImage) -> ()) {
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) {
            completion(imageFromCache)
        }
        
        if let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: urlString as AnyObject)
                        completion(image)
                        return
                    }
                }
                completion(defaultImage)
            }
        }
    }
}
