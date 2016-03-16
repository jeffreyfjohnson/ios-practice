//
//  Photo.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/15/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class Photo {
    let title: String
    let remoteUrl: NSURL
    let photoId: String
    let dateTaken: NSDate
    var image: UIImage?
    
    init(title: String, remoteUrl: NSURL, photoId: String, dateTaken: NSDate){
        self.title = title
        self.remoteUrl = remoteUrl
        self.photoId = photoId
        self.dateTaken = dateTaken
    }
    
}