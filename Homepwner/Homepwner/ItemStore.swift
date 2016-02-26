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
    
    init() {
        for _ in 0..<15{
            createItem()
        }
    }
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        items.append(newItem)
        
        return newItem
    }
}
