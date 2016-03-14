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

struct FlickrApi {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "a6d819499131071f158fd740860a5a88"
    
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
}