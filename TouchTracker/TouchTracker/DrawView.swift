//
//  DrawView.swift
//  TouchTracker
//
//  Created by Solstice Loaner on 3/4/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class DrawView: UIView{
    
    var currentLine: Line?
    var finishedLines = [Line]()
    
    //MARK: Touch Handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        
        currentLine = Line(begin: touch.locationInView(self), end: touch.locationInView(self))
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        currentLine?.end = touches.first!.locationInView(self)
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if var line = currentLine {
            line.end = touches.first!.locationInView(self)
            finishedLines.append(line)
        }
        
        currentLine = nil
        setNeedsDisplay()
    }
    
    //MARK: Drawing
    func strokeLine(currentLine: Line){
        let path = UIBezierPath()
        path.lineCapStyle = .Round
        path.lineWidth = 10
        
        path.moveToPoint(currentLine.begin)
        path.addLineToPoint(currentLine.end)
        path.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        UIColor.blackColor().setStroke();
        
        for line in finishedLines {
            strokeLine(line)
        }
        
        if let line = currentLine {
            UIColor.redColor().setStroke()
            strokeLine(line)
        }
        
    }
    
    
}
