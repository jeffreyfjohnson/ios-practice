//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Solstice Loaner on 3/14/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var photoStore: PhotoStore!
    let photoDataSource = PhotoDataSource()
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        photoStore.fetchRecentPhotos(){
            (photosResult) -> Void in
            
            let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
            let allPhotos = try! self.photoStore.fetchMainQueuePhotos(predicate: nil, sortDescriptors: [sortByDateTaken])
            
            NSOperationQueue.mainQueue().addOperationWithBlock{
                self.photoDataSource.photos = allPhotos
                self.collectionView.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let photo = photoDataSource.photos[indexPath.row]
        
        photoStore.fetchImageForPhoto(photo){ (result) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                () -> Void in
                
                let photoIndex = self.photoDataSource.photos.indexOf(photo)!
                let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                
                if let cell = collectionView.cellForItemAtIndexPath(photoIndexPath) as? PhotoCollectionViewCell {
                    cell.updateWithImage(photo.image)
                }
            }
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto"{
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first{
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let photoInfoVC = segue.destinationViewController as! PhotoInfoViewController
                
                photoInfoVC.photo = photo
                photoInfoVC.photoStore = photoStore
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellWidth = (view.bounds.width - 10) / 4.0
        
        return CGSize(width: cellWidth, height: cellWidth)
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.reloadData()
    }
}
