//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/14/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    var photoStore: PhotoStore!
    let photoDataSource = PhotoDataSource()
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        
        photoStore.fetchRecentPhotos(){
            (photosResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock{
                () -> Void in
                switch photosResult{
                case let .Success(photos):
                    print("found \(photos.count) photos")
                    self.photoDataSource.photos = photos
                case let .Failure(error):
                    print("error fetching recents: \(error)")
                    self.photoDataSource.photos.removeAll()
                }
                
                self.collectionView.reloadData()
            }
        }
    }
}
