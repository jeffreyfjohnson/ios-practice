//
//  DateSelectViewController.swift
//  Homepwner
//
//  Created by Solstice Loaner on 2/29/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class DateSelectViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.setDate(item.dateCreated, animated: true)
    }
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        item.dateCreated = sender.date
    }
    
}
