//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Jeffrey Johnson on 1/12/16.
//  Copyright © 2016 Jeffrey Johnson. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet var celciusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    var fahrenheitValue: Double?{
        didSet{
            updateCelciusValue()
        }
    }
    var celciusValue: Double?{
        if let fahrenheit = fahrenheitValue{
            return (fahrenheit-32)*(5/9)
        }
        else{
            return nil
        }
    }
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField){
        if let text = textField.text, number = numberFormatter.numberFromString(text){
            fahrenheitValue = number.doubleValue
        }else{
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject){
        textField.resignFirstResponder()
    }
    
    func updateCelciusValue(){
        if let value = celciusValue{
            celciusLabel.text = numberFormatter.stringFromNumber(value)
        }
        else{
            celciusLabel.text = "???"
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let currentLocale = NSLocale.currentLocale()
        let decimalSep = currentLocale.objectForKey(NSLocaleDecimalSeparator) as! String
        
        let existingTextHasDecimal = textField.text?.rangeOfString(decimalSep)
        let newTextHasDecimal = string.rangeOfString(decimalSep)
        let allowedSet = NSCharacterSet(charactersInString: ",.1234567890-")
        
        let rangeOfNonDecimal = string.rangeOfCharacterFromSet(allowedSet.invertedSet)
        
        if (rangeOfNonDecimal != nil){
            return false
        }
        
        if (existingTextHasDecimal != nil && newTextHasDecimal != nil){
            return false
        }
        else{
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("convert")
    }
    
    override func viewWillAppear(animated: Bool) {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        self.view.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    
}
