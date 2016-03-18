//
//  Photo.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/18/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit
import CoreData


class Photo: NSManagedObject {
    
    var image: UIImage?
    
    override func awakeFromInsert() {
        title = ""
        photoID = ""
        remoteURL = NSURL()
        photoKey = NSUUID().UUIDString
        dateTaken = NSDate()
    }
}
