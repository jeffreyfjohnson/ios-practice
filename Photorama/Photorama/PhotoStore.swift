//
//  PhotoStore.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/15/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import Foundation

class PhotoStore {
    
    let session : NSURLSession = {
       let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchRecentPhotos(){
        
        let url = FlickrApi.recentPhotosUrl()
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if let jsonData = data{
                do{
                    let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
                    print(jsonObject)
                }
                catch let error {
                    print("error parsing recents json: \(error)")
                }
            }
            else if let requestError = error {
                print("error fetching recents: \(requestError)")
            }
            else{
                print("unexpected error fetching recents")
            }
        }
        task.resume()
    }
}
