//
//  ItemCell.swift
//  Homepwner
//
//  Created by Solstice Loaner on 2/26/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell{
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var serialNumberLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    func updateLabels(valueGreen: Bool){
        let bodyFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        nameLabel.font = bodyFont
        valueLabel.font = bodyFont
        if !valueGreen {
            valueLabel.textColor = UIColor(red: 0.95, green: 0.05, blue: 0.07, alpha: 1)
        }
        else{
            valueLabel.textColor = UIColor(red: 0.15, green: 0.93, blue: 0.12, alpha: 1)
        }
        
        let captionFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        serialNumberLabel.font = captionFont
    }
    
}
