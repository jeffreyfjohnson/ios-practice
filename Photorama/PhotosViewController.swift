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
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoStore.fetchRecentPhotos(){
            (photosResult) -> Void in
            
            switch photosResult{
            case let .Success(photos):
                print("found \(photos.count) photos")
                
                if let firstPhoto = photos.first {
                    self.photoStore.fetchImageForPhoto(firstPhoto) {
                        (imageResult) -> Void in
                        
                        switch imageResult{
                        case let .Success(image):
                        
                            NSOperationQueue.mainQueue().addOperationWithBlock{
                                () -> Void in
                                self.imageView.image = image
                            }

                        case let .Failure(error):
                            print("error downloading image: \(error)")
                        }
                    }
                }
            case let .Failure(error):
                print("error fetching recents: \(error)")
            }
        }
    }
}
