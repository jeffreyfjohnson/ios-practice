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
        
        photoStore.fetchRecentPhotos()
    }
}
