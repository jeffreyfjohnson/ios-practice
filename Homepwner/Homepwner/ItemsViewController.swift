//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by Solstice Loaner on 2/25/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController{
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Low-polygon-iphone-6-background")!)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addNewItem(sender: AnyObject){
        let newItem = itemStore.createItem()
        
        if let index = itemStore.items.indexOf(newItem){
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.items.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->UITableViewCell {
        
        if indexPath.row == itemStore.items.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("SimpleCell", forIndexPath: indexPath)
            cell.textLabel?.text = "No more items!!!"
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        
        let item = itemStore.items[indexPath.row]
        cell.updateLabels(item.valueInDollars < 50)
        
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = String(item.valueInDollars)
    
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == itemStore.items.count{
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let itemToDelete = itemStore.items[indexPath.row]
            
            let title = "Delete \(itemToDelete.name) ?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: {
                (action) -> Void in
                self.itemStore.removeItem(itemToDelete)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                self.imageStore.deleteImage(forKey: itemToDelete.itemKey)
            })
            ac.addAction(deleteAction)
            
            presentViewController(ac, animated: true, completion: nil)
            
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
        
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if (proposedDestinationIndexPath.row == itemStore.items.count){
            return NSIndexPath(forRow: itemStore.items.count - 1, inSection: 0)
        }
        return proposedDestinationIndexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowItem" {
            
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.items[row]
                let detailViewController = segue.destinationViewController as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
            
        }
    }
    
}
