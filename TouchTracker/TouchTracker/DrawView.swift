//
//  DrawView.swift
//  TouchTracker
//
//  Created by Solstice Loaner on 3/4/16.
//  Copyright © 2016 Solstice Loaner. All rights reserved.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate{
    
    var currentLine: Line?
    var currentTouches = [NSValue: CGPoint]()
    var finishedLines = [Line]()
    var finishedCircles = [(CGPoint, CGPoint)]()
    var selectedLineIndex: (line: Bool, index: Int?){
        didSet{
            if selectedLineIndex.index == nil{
                let menu = UIMenuController.sharedMenuController()
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    var moveRecognizer: UIPanGestureRecognizer!
    var ignoreTouch = false
    
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
    
    var currentLineThickness: CGFloat
    
    //MARK: init
    required init?(coder aDecoder: NSCoder) {
        selectedLineIndex = (false, nil)
        currentLineThickness = lineThickness
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "singleTap:")
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPress:")
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self, action: "moveLine:")
        moveRecognizer.cancelsTouchesInView = false
        moveRecognizer.delegate = self
        addGestureRecognizer(moveRecognizer)
    }
    
    //MARK: Gesture Handling
    func singleTap(gestureRecognizer: UIGestureRecognizer){
        let point = gestureRecognizer.locationInView(self)
        setSelectedLineIndex(point)
        
        let menu = UIMenuController.sharedMenuController()
        
        if selectedLineIndex.index != nil{
             becomeFirstResponder()
            
            let deleteItem = UIMenuItem(title: "Delete", action: "deleteLine:")
            menu.menuItems = [deleteItem]
            
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height: 2), inView: self)
            menu.setMenuVisible(true, animated: true)
        }
        else{
            menu.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    func doubleTap(gestureRecognizer: UIGestureRecognizer){
        currentTouches.removeAll()
        currentLine = nil
        finishedCircles.removeAll()
        finishedLines.removeAll()
        selectedLineIndex = (false, nil)
        
        setNeedsDisplay()
    }
    
    func longPress(gestureRecognizer: UIGestureRecognizer){
        
        if gestureRecognizer.state == .Began{
            let point = gestureRecognizer.locationInView(self)
            setSelectedLineIndex(point)
            
            if selectedLineIndex.index != nil {
                currentLine = nil
                currentTouches.removeAll()
            }
        }
        else if gestureRecognizer.state == .Ended{
            selectedLineIndex.index = nil
        }
        
        setNeedsDisplay()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - Line management
    func deleteLine(sender: AnyObject){
        if let index = selectedLineIndex.index{
            if selectedLineIndex.line {
                finishedLines.removeAtIndex(index)
            }
            else{
               finishedCircles.removeAtIndex(index)
            }
            
            selectedLineIndex.index = nil
            setNeedsDisplay()
        }
    }
    
    func moveLine(gestureRecognizer: UIPanGestureRecognizer){
        
        if let index = selectedLineIndex.index {
            if gestureRecognizer.state == .Changed {
                let translation = gestureRecognizer.translationInView(self)
                
                if selectedLineIndex.line {
                    finishedLines[index].begin.x += translation.x
                    finishedLines[index].begin.y += translation.y
                    finishedLines[index].end.x += translation.x
                    finishedLines[index].end.y += translation.y
                }else{
                    
                    finishedCircles[index].0.x += translation.x
                    finishedCircles[index].0.y += translation.y
                    finishedCircles[index].1.x += translation.x
                    finishedCircles[index].1.y += translation.y
                }
                
                gestureRecognizer.setTranslation(CGPoint.zero, inView: self)
                
                let velo = gestureRecognizer.velocityInView(self)
                currentLineThickness = clamp(hypot(velo.x, velo.y)/100, max: 15, min: 4)
                
                setNeedsDisplay()
            }
        }
    }
    //MARK - Utility
    
    func clamp(value: CGFloat, max: CGFloat, min:CGFloat) -> CGFloat{
        if value > max{
            return max
        }
        if value < min{
            return min
        }
        else{
            return value
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func setSelectedLineIndex(point: CGPoint){
        let closestLine = indexOfLineAtPoint(point)
        let closestCircle = indexOfCircleAtPoint(point)
        if let lineDist = closestLine.distance, circDist = closestCircle.distance {
            let lineCloser = lineDist < circDist
            selectedLineIndex = (lineCloser, lineCloser ? closestLine.index : closestCircle.index)
        }
        else if let _ = closestLine.distance{
            selectedLineIndex = (true, closestLine.index)
        }
        else if let _ = closestCircle.distance{
            selectedLineIndex = (false, closestCircle.index)
        }
        else{
            selectedLineIndex = (false, nil)
        }
        
    }
    
    func indexOfLineAtPoint(point: CGPoint) -> (index: Int?, distance: CGFloat?){
        
        for (index, line) in finishedLines.enumerate() {
            let begin = line.begin
            let end = line.end
            
            for t in CGFloat(0).stride(to: 1.0, by: 0.05){
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                let h = hypot(x - point.x, y - point.y)
                if h < 20 {
                    return (index, h)
                }
            }
        }
        
        return (nil, nil)
    }
    
    func indexOfCircleAtPoint(point: CGPoint) -> (index: Int?, distance: CGFloat?){
        
        for (index, circle) in finishedCircles.enumerate() {
            let mid = midpoint(circle.0, circle.1)
            let radius = distance(mid, circle.0)
            
            for t in CGFloat(0).stride(to: CGFloat(2 * M_PI), by: 0.05){
                
                let x = mid.x + radius * cos(t)
                let y = mid.y + radius * sin(t)
                
                let h = hypot(x - point.x, y - point.y)
                if h < 20 {
                    return (index, h)
                }
            }
        }
        return (nil, nil)
    }
    
    //MARK: Touch Handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if selectedLineIndex.index != nil{
            selectedLineIndex.index = nil
            setNeedsDisplay()
            ignoreTouch = true
            return
        }
        else{
            ignoreTouch = false
        }
        
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
        
        if !ignoreTouch {
            for touch in touches {
                 currentTouches[valueForTouch(touch)] = touch.locationInView(self)
            }
            
            if var line = currentLine, let touch = currentTouches.values.first {
                line.end = touch
                currentLine = line
            }
           
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !ignoreTouch {
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
    func strokeLine(currentLine: Line, thickness: CGFloat){
        let path = UIBezierPath()
        path.lineCapStyle = .Round
        path.lineWidth = thickness
        
        path.moveToPoint(currentLine.begin)
        path.addLineToPoint(currentLine.end)
        path.stroke()
    }
    
    func strokeCircle(pointA: CGPoint, pointB: CGPoint, thickness: CGFloat){
        let path = UIBezierPath(arcCenter: midpoint(pointA, pointB), radius: distance(pointA, pointB)/2.0, startAngle: 0, endAngle: CGFloat(2.0 * M_PI), clockwise: true)
        
        path.lineWidth = thickness
        path.stroke()
    }
    
    override func drawRect(rect: CGRect) {
        finishedLineColor.setStroke();
        
        for line in finishedLines {
            strokeLine(line, thickness: lineThickness)
        }
        
        finishedCircleColor.setStroke()
        
        for (pointA, pointB) in finishedCircles {
            strokeCircle(pointA, pointB: pointB,  thickness: lineThickness)
        }
        
        currentLineColor.setStroke()
        
        if let line = currentLine {
            let height = abs(line.end.y - line.begin.y)
            let length = abs(line.end.x - line.begin.x)
            let angle = atan(Double(height) / Double(length))
            
            interpolateColor(currentLineColor, b: currentLineColorInterpolate, t: CGFloat(angle / (M_PI / 2.0))).setStroke()
            
            strokeLine(line,  thickness: lineThickness)
        }
        else{
            var points = [CGPoint]()
            
            for touch in currentTouches.values {
                points.append(touch)
            }
            
            if (points.count >= 2){
                strokeCircle(points[0], pointB: points[1],  thickness: lineThickness)
            }
        }
        
        if let index = selectedLineIndex.index {
            UIColor.greenColor().setStroke()
            if selectedLineIndex.line {
                strokeLine(finishedLines[index], thickness: currentLineThickness)
            }
            else {
                let points = finishedCircles[index]
                strokeCircle(points.0, pointB: points.1, thickness: currentLineThickness)
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
