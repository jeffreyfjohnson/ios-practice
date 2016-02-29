//
//  ImageStore.swift
//  Homepwner
//
//  Created by Solstice Loaner on 2/29/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class ImageStore {
    
    let cache = NSCache()
    
    func setImage(image: UIImage, forKey key: String){
        cache.setObject(image, forKey: key)
    }
    
    func getImage(forKey key: String) -> UIImage?{
        return cache.objectForKey(key) as? UIImage
    }
    
    func deleteImage(forKey key: String){
        cache.removeObjectForKey(key)
    }
    
}
