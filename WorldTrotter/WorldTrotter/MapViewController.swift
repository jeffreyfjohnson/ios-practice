//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Jeffrey Johnson on 1/13/16.
//  Copyright © 2016 Jeffrey Johnson. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate{
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let locationQueue = [CLLocationCoordinate2DMake(37.8499, -119.5677),
                            CLLocationCoordinate2DMake(63.333, -150.5)]
    var locationQueueIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("map")
    }
    
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        
        if (!CLLocationManager.locationServicesEnabled()){
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.showsUserLocation = true
        
        let standardString =  NSLocalizedString("Standard", comment: "Standard map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leftConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let rightConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        topConstraint.active = true
        leftConstraint.active = true
        rightConstraint.active = true
        
        drawButtons()
        
        for location in locationQueue{
            let pin = MKPointAnnotation()
            pin.coordinate = location
            mapView.addAnnotation(pin)
        }
    }
    
    func drawButtons(){
        let locateMeButton = UIButton(type: .System)
        let locateMeString = NSLocalizedString("Locate Me", comment: "locate me map button")
        locateMeButton.setTitle(locateMeString, forState: .Normal)
        locateMeButton.translatesAutoresizingMaskIntoConstraints = false
        locateMeButton.backgroundColor = UIColor.whiteColor()
        locateMeButton.layer.cornerRadius = 5
        view.addSubview(locateMeButton)
        
        locateMeButton.addTarget(self, action: "locateMe:", forControlEvents: .TouchUpInside)
        
        let interestingPointsButton = UIButton(type: .System)
        let interestingPointsString = NSLocalizedString("Interesting Points", comment: "interesting points map button")
        interestingPointsButton.setTitle(interestingPointsString, forState: .Normal)
        interestingPointsButton.backgroundColor = UIColor.whiteColor()
        interestingPointsButton.layer.cornerRadius = 5
        interestingPointsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(interestingPointsButton)
        
        interestingPointsButton.addTarget(self, action: "cyclePoints:", forControlEvents: .TouchUpInside)
        
        let margins = view.layoutMarginsGuide
        let bottomConstraint = locateMeButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor, constant: -10)
        let interestingBottomConstraint = interestingPointsButton.bottomAnchor.constraintEqualToAnchor(bottomLayoutGuide.topAnchor, constant: -10)
        let locateMeLeftConstraint = locateMeButton.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let interestingRightConstraint = interestingPointsButton.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        bottomConstraint.active = true
        interestingBottomConstraint.active = true
        locateMeLeftConstraint.active = true
        interestingRightConstraint.active = true
    }
    
    func mapTypeChanged(segmentControl: UISegmentedControl){
        switch segmentControl.selectedSegmentIndex{
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }
    
    func locateMe(button: UIButton){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        let permission = CLLocationManager.authorizationStatus()
        
        if permission == .NotDetermined{
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.requestLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last{
            goToPoint(lastLocation.coordinate)
        }
    }
    
    func goToPoint(location: CLLocationCoordinate2D){
        var region = MKCoordinateRegion()
        region.center = location
        region.span = MKCoordinateSpanMake(0.2, 0.2)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error loading map: \(error)")
    }
    
    func cyclePoints(button: UIButton){
        goToPoint(locationQueue[locationQueueIndex])
        ++locationQueueIndex
        if locationQueueIndex >= locationQueue.count{
            locationQueueIndex = 0
        }
    }
    
}
