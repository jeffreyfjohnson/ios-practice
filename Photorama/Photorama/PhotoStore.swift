//
//  PhotoStore.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/15/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

enum ImageResult{
    case Success(UIImage)
    case Failure(ErrorType)
}

enum PhotoError:ErrorType{
    case ImageCreationError
}

class PhotoStore {
    
    let session : NSURLSession = {
       let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchRecentPhotos(completion completion: (PhotosResult)-> Void){
        
        let url = FlickrApi.recentPhotosUrl()
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print("code \(httpResponse.statusCode)")
                print("headers \(httpResponse.allHeaderFields)")
            }
            
            let result = self.processRecentPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    func processRecentPhotosRequest(data data: NSData?, error: NSError?) -> PhotosResult {
        guard let responseData = data else {
            return .Failure(error!)
        }
        
        return FlickrApi.photosFromJsonData(responseData)
    }
    
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> Void){
        
        if let currentPhoto = photo.image {
            completion(.Success(currentPhoto))
            return
        }
        
        let request = NSURLRequest(URL: photo.remoteUrl)
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            
            if case let .Success(image) = result {
                photo.image = image
            }
            
            completion(result)
            
        }
        task.resume()
        
    }
    
    func processImageRequest(data data: NSData?, error: ErrorType?) -> ImageResult{
        
        guard let imageData = data,
            image = UIImage(data: imageData) else{
                
            if data == nil {
                return .Failure(error!)
            }
            else{
                return .Failure(PhotoError.ImageCreationError)
            }
        }
        
        return .Success(image)
        
    }
}
