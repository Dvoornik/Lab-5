//
//  ViewController.swift
//  CIS55_Lab4
//
//  Created by Sergey on 6/24/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var destination: UITextField!
    @IBOutlet weak var route: UITextView!
  
    
    var myLockMgr = CLLocationManager()
    var myGeoCoderFrom = CLGeocoder()
    var myGeoCoderTo = CLGeocoder()
    var showPlacemarkFrom : CLPlacemark?
    var showPlacemarkTo : CLPlacemark?
    let annotationFrom = MKPointAnnotation()
    let annotationTo = MKPointAnnotation()
    
    var toAddr : String?
    var fromAddr : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myLockMgr.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            self.myMap.showsUserLocation = true
        }
        myMap.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

        @IBAction func directions(_ sender: Any) {
            
            startLocation.resignFirstResponder()
            destination.resignFirstResponder()
            self.fromAddr = self.startLocation!.text
            self.toAddr = self.destination!.text
            if self.fromAddr!.characters.count == 0 || self.toAddr!.characters.count == 0  {
                
                let alertController = UIAlertController(title: "Attention", message: "Please enter two locations", preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                present(alertController, animated: true, completion: nil)
            }
            
            else {
                
                self.getData()
            
            
            // dalay one second to execute calculating route
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
        self.calculateRout()})
        }
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) ->
        MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 3.0
            return renderer
    }
    
// Create to points from text fields
    
    func getData() {
        //self.fromAddr = self.startLocation!.text
        //self.toAddr = self.destination!.text
        
        
        myGeoCoderFrom.geocodeAddressString(fromAddr!, completionHandler:{ placemarks, error in
            
            if error != nil {
                print (error!)
                return
            }
            if placemarks != nil && placemarks!.count > 0 {
                let placemarkFrom = placemarks![0] as CLPlacemark
                self.showPlacemarkFrom = placemarkFrom
                
                
                
                self.annotationFrom.title = placemarkFrom.name
                self.annotationFrom.subtitle = self.fromAddr
                self.annotationFrom.coordinate = placemarkFrom.location!.coordinate
                
                
            }
            
        })
        myGeoCoderTo.geocodeAddressString(toAddr!, completionHandler:{ placemarks, error in
            
            if error != nil {
                print (error!)
                return
            }
            if placemarks != nil && placemarks!.count > 0 {
                let placemarkTo = placemarks![0] as CLPlacemark
                self.showPlacemarkTo = placemarkTo
                
                
                self.annotationTo.title = placemarkTo.name
                self.annotationTo.subtitle = self.toAddr
                self.annotationTo.coordinate = placemarkTo.location!.coordinate
                
                
            }
            
        })
        
    }


// Calculate Route
    
    func calculateRout() {
        self.myMap.showAnnotations([self.annotationTo, self.annotationFrom], animated: true)
        
        let dirRq = MKDirectionsRequest()
        let MyTransportType = MKDirectionsTransportType.automobile
        var myRoute : MKRoute?
        var showRoute = ""
        
        dirRq.source = MKMapItem(placemark: MKPlacemark(placemark: showPlacemarkFrom!))
        dirRq.destination = MKMapItem(placemark: MKPlacemark(placemark: showPlacemarkTo!))
        dirRq.transportType = MyTransportType
        
        let myDirs = MKDirections(request: dirRq) as MKDirections
        myDirs.calculate(completionHandler: { routeResponse, routeError in
            if routeError != nil {
                print (routeError!)
                return
            }
            // Get the first route
            myRoute = routeResponse?.routes[0] as MKRoute!
            //Remove any existing route line and add a new one
            self.myMap.removeOverlays(self.myMap.overlays)
            self.myMap.add((myRoute?.polyline)!, level: MKOverlayLevel.aboveRoads)
            //Scale the map to show the whole route.
            let rect = myRoute?.polyline.boundingMapRect
            self.myMap.setRegion(MKCoordinateRegionForMapRect(rect!), animated: true)
            //Get the route steps to show on screen
            if let steps = myRoute?.steps as [MKRouteStep]! {
                var i = 1
                for step in steps {
                    showRoute = showRoute + String(i) + ". " + step.instructions + "\n"
                    i = i + 1
                    
                }
                self.route.text = showRoute
                self.startLocation.text = ""
                self.destination.text = ""
            }
            
        })

    }

    

}

