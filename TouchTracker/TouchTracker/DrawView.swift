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
    var currentTouches = [NSValue: CGPoint]()
    var finishedLines = [Line]()
    var finishedCircles = [(CGPoint, CGPoint)]()
    
    //MARK: Inspectables
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.blackColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColorInterpolate: UIColor = UIColor.redColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.redColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentCircleColor: UIColor = UIColor.greenColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var finishedCircleColor: UIColor = UIColor.grayColor(){
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
            currentTouches[valueForTouch(touch)] = touch.locationInView(self)
        }
        
        if currentTouches.count == 1{
            if let touch = currentTouches.values.first{
                currentLine = Line(begin: touch, end: touch);
            }
        }
        else {
            currentLine = nil
        }

        
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
             currentTouches[valueForTouch(touch)] = touch.locationInView(self)
        }
        
        if var line = currentLine, let touch = currentTouches.values.first {
            line.end = touch
            currentLine = line
        }
       
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if var line = currentLine, let touch = touches.first {
            line.end = touch.locationInView(self)
            finishedLines.append(line)
            currentTouches.removeValueForKey(valueForTouch(touch))
            currentLine = nil
        }
        else {
            var points = [CGPoint]()
            
            for touch in touches {
                points.append(touch.locationInView(self))
            }
            
            finishedCircles.append((points[0], points[1]))
            currentTouches.removeAll()
        }

        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        currentTouches.removeAll()
        currentLine = nil
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
    
    func strokeCircle(pointA: CGPoint, pointB: CGPoint){
        let path = UIBezierPath(arcCenter: midpoint(pointA, pointB), radius: distance(pointA, pointB)/2.0, startAngle: 0, endAngle: CGFloat(2.0 * M_PI), clockwise: true)
        
        path.lineWidth = lineThickness
        path.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        finishedLineColor.setStroke();
        
        for line in finishedLines {
            strokeLine(line)
        }
        
        finishedCircleColor.setStroke()
        
        for (pointA, pointB) in finishedCircles {
            strokeCircle(pointA, pointB: pointB)
        }
        
        currentLineColor.setStroke()
        
        if let line = currentLine {
            let height = abs(line.end.y - line.begin.y)
            let length = abs(line.end.x - line.begin.x)
            let angle = atan(Double(height) / Double(length))
            
            interpolateColor(currentLineColor, b: currentLineColorInterpolate, t: CGFloat(angle / (M_PI / 2.0))).setStroke()
            
            strokeLine(line)
        }
        else{
            var points = [CGPoint]()
            
            for touch in currentTouches.values {
                points.append(touch)
            }
            
            if (points.count >= 2){
                strokeCircle(points[0], pointB: points[1])
            }
        }
        
        
    }
    
    func midpoint(a: CGPoint, _ b: CGPoint) -> CGPoint{
        return CGPoint(x: (a.x+b.x)/CGFloat(2.0), y: (a.y+b.y)/CGFloat(2.0));
    }
    
    func distance(a: CGPoint, _ b: CGPoint) -> CGFloat{
        return CGFloat(sqrt(pow((a.x - b.x), 2) + pow((a.y - b.y), 2)))
    }
    
    func interpolateColor(a: UIColor, b: UIColor, t: CGFloat) -> UIColor{
        let colorA = CIColor(color: a)
        let colorB = CIColor(color: b)
        
        let r = (1 - t) * colorA.red + t * colorB.red
        let g = (1 - t) * colorA.green + t * colorB.green
        let b = (1 - t) * colorA.blue + t * colorB.blue
        
        let lerpColor = CIColor(red: r, green: g, blue: b)
        return UIColor(CIColor: lerpColor)
    }
    
    
}
