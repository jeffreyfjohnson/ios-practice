//
//  DocUtil.swift
//  Homepwner
//
//  Created by Solstice Loaner on 3/2/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import Foundation

class DocUtil{
    
    static func getFilePathUrl(file: String) -> NSURL {
        let documentsDirectories = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent(file)
    }
    
}
