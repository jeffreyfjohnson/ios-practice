//
//  BorderChangeTextField.swift
//  Homepwner
//
//  Created by Solstice Loaner on 2/29/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class BorderChangeTextField: UITextField{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderStyle = .None
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        borderStyle = .RoundedRect
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        borderStyle = .None
        return true
    }
}
