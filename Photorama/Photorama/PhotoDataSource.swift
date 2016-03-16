//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/16/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [Photo]()
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        
        return cell
    }
}