//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Solstice Loaner on 2/26/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    
    let numberFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
    }
    
    var item: Item!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialField.text = item.serialNumber
        valueField.text = String(item.valueInDollars)
        dateLabel.text = String(item.dateCreated)
    }
    
}
