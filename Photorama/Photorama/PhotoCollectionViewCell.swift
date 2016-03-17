//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/16/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activitySpinner: UIActivityIndicatorView!
    
    func updateWithImage(image: UIImage?){
        if let imageToDisplay = image{
            imageView.image = imageToDisplay
            activitySpinner.stopAnimating()
        }
        else{
            imageView.image = nil
            activitySpinner.startAnimating()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateWithImage(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateWithImage(nil)
    }
}
