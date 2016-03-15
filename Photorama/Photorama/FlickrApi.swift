//
//  FlickrApi.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/14/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import Foundation

enum Method: String{
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotosResult{
    case Success([Photo])
    case Failure(ErrorType)
}

enum FlickrError: ErrorType{
    case InvalidJSONData
}

struct FlickrApi {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
    private static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func flickrUrl(method method: Method, params: [String : String]?) -> NSURL{
        
        let components = NSURLComponents(string: baseURLString)!
        var queryItems = [NSURLQueryItem]()
        
        let baseParams = [
            "method" : method.rawValue,
            "format" : "json",
            "nojsoncallback" : "1",
            "api_key" : APIKey
        ]
        
        for (key, value) in baseParams {
            let item = NSURLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let qParams = params{
            for (key, value) in qParams {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.URL!
    }
    
    static func recentPhotosUrl() -> NSURL{
        return flickrUrl(method: .RecentPhotos, params: ["extras" : "url_h,date_taken"])
    }
    
    static func photosFromJsonData(jsonData: NSData) -> PhotosResult{
        
        do{
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            
            guard let jsonDictionary = jsonObject as? [NSObject : AnyObject], photos = jsonDictionary["photos"] as? [String:AnyObject], photosArray = photos["photo"] as? [[String:AnyObject]] else {
                return .Failure(FlickrError.InvalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            return .Success(finalPhotos)
        }
        catch let error{
            return .Failure(error)
        }
        
    }
}