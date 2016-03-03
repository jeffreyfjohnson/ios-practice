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
        
        let imageUrl = imageUrlForKey(key)
        
        if let data = UIImagePNGRepresentation(image){
            data.writeToURL(imageUrl, atomically: true)
        }
    }
    
    func getImage(forKey key: String) -> UIImage?{
        
        if let existingImage = cache.objectForKey(key) as? UIImage{
            return existingImage
        }
        
        let imageUrl = imageUrlForKey(key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageUrl.path!) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String){
        cache.removeObjectForKey(key)
        
        let imageUrl = imageUrlForKey(key)
        do{
            try NSFileManager.defaultManager().removeItemAtURL(imageUrl)
        }
        catch {
            print("error deleting file: \(error)")
        }
    }
    
    func imageUrlForKey(key: String) -> NSURL{
        return DocUtil.getFilePathUrl(key)
    }
    
}
