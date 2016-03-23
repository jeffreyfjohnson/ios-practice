//
//  PhotoStore.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/15/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit
import CoreData

enum ImageResult{
    case Success(UIImage)
    case Failure(ErrorType)
}

enum PhotoError:ErrorType{
    case ImageCreationError
}

class PhotoStore {
    
    let coreDataStack = CoreDataStack(modelName: "Photorama")
    
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
            
            var result = self.processRecentPhotosRequest(data: data, error: error)
            
            if case let .Success(photos) = result{
                let mainQueueContext = self.coreDataStack.mainQueueContext
                mainQueueContext.performBlockAndWait(){
                    try! mainQueueContext.obtainPermanentIDsForObjects(photos)
                }
                let objectIds = photos.map{$0.objectID}
                let predicate = NSPredicate(format: "self IN %@", objectIds)
                let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
                do{
                    try self.coreDataStack.saveChanges()
                    
                    let mainQueuePhotos = try self.fetchMainQueuePhotos(predicate: predicate, sortDescriptors: [sortByDateTaken])
                    result = .Success(mainQueuePhotos)
                }
                catch let error{
                    result = .Failure(error)
                }
            }
            
            completion(result)
        }
        task.resume()
    }
    
    func processRecentPhotosRequest(data data: NSData?, error: NSError?) -> PhotosResult {
        guard let responseData = data else {
            return .Failure(error!)
        }
        
        return FlickrApi.photosFromJsonData(responseData, inContext: self.coreDataStack.mainQueueContext)
    }
    
    func fetchImageForPhoto(photo: Photo, completion: (ImageResult) -> Void){
        
        if let currentPhoto = photo.image {
            completion(.Success(currentPhoto))
            return
        }
        
        let request = NSURLRequest(URL: photo.remoteURL)
        
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
    
    func fetchMainQueuePhotos(predicate predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> [Photo]{
        
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueuePhotos: [Photo]?
        var fetchRequestError: ErrorType?
        mainQueueContext.performBlockAndWait(){
            () -> Void in
            do {
                mainQueuePhotos = try mainQueueContext.executeFetchRequest(fetchRequest) as? [Photo]
            }
            catch let error{
                fetchRequestError = error
            }
        }
        
        guard let photos = mainQueuePhotos else {
            throw fetchRequestError!
        }
        
        return photos
    }
}
