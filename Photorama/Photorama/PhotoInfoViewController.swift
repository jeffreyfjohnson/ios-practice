//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/16/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet{
            navigationItem.title = photo.title
        }
    }
    var photoStore: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoStore.fetchImageForPhoto(photo){
            (result) -> Void in
            
            switch result{
            case let .Success(image):
                NSOperationQueue.mainQueue().addOperationWithBlock(){
                    () -> Void in
                    self.imageView.image = image
                }
            case let .Failure(error):
                print("error fetching image \(error)")
            }
            
        }
    }
}
