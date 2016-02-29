//
//  DateSelectViewController.swift
//  Homepwner
//
//  Created by Solstice Loaner on 2/29/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class DateSelectViewController: UIViewController {
    
    var item: Item!
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        item.dateCreated = sender.date
    }
    
}
