//
//  DrawView.swift
//  TouchTracker
//
//  Created by Solstice Loaner on 3/4/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class DrawView: UIView{
    
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.blackColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.redColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10{
        didSet{
            setNeedsDisplay()
        }
    }
    
    //MARK: Touch Handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let newLine = Line(begin: touch.locationInView(self), end: touch.locationInView(self));
            
            currentLines[valueForTouch(touch)] = newLine
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
             currentLines[valueForTouch(touch)]?.end =  touch.locationInView(self)
        }
       
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches{
            
            if var current = currentLines[valueForTouch(touch)]{
                current.end = touch.locationInView(self)
                finishedLines.append(current)
                currentLines.removeValueForKey(valueForTouch(touch))
            }
            
        }
        
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    private func valueForTouch(touch: UITouch) -> NSValue{
        return NSValue(nonretainedObject: touch)
    }
    
    //MARK: Drawing
    func strokeLine(currentLine: Line){
        let path = UIBezierPath()
        path.lineCapStyle = .Round
        path.lineWidth = lineThickness
        
        path.moveToPoint(currentLine.begin)
        path.addLineToPoint(currentLine.end)
        path.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        finishedLineColor.setStroke();
        
        for line in finishedLines {
            strokeLine(line)
        }
        
        currentLineColor.setStroke()
        
        for (_ , line) in currentLines {
            strokeLine(line)
        }
        
    }
    
    
}
