//
//  ItemStore.swift
//  Homepwner
//
//  Created by Solstice Loaner on 2/25/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class ItemStore {
    var items = [Item]()
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        items.append(newItem)
        
        return newItem
    }
    
    func removeItem(item: Item){
        if let index = items.indexOf(item){
            items.removeAtIndex(index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int){
        
        let movedItem = items[fromIndex]
        items.removeAtIndex(fromIndex)
        items.insert(movedItem, atIndex: toIndex)
    }
}
