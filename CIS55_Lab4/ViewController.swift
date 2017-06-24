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
    var myGeoCoder = CLGeocoder()
    var showPlacemark : CLPlacemark?
    
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
    

    @IBAction func locate(_ sender: Any) {
        
        self.fromAddr = self.startLocation!.text

        
        myGeoCoder.geocodeAddressString(fromAddr!, completionHandler:{ placemarks, error in
            
            if error != nil {
            print (error!)
            return
            }
            if placemarks != nil && placemarks!.count > 0 {
            let placemark = placemarks![0] as CLPlacemark
            self.showPlacemark = placemark
                
            let annotationFrom = MKPointAnnotation()
            
            annotationFrom.title = placemark.name
            annotationFrom.subtitle = self.fromAddr
            annotationFrom.coordinate = placemark.location!.coordinate
            self.myMap.showAnnotations([annotationFrom], animated: true)
            
    }
        
    })
        
}
    
    @IBAction func directions(_ sender: Any) {
        
        let dirRq = MKDirectionsRequest()
        let MyTransportType = MKDirectionsTransportType.automobile
        var myRoute : MKRoute?
        var showRoute = ""
        
        dirRq.source = MKMapItem.forCurrentLocation()
        dirRq.destination = MKMapItem(placemark: MKPlacemark(placemark: showPlacemark!))
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
                for step in steps {
                    showRoute = showRoute + step.instructions
                }
                self.route.text = showRoute
            }
            
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) ->
        MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.red
            renderer.lineWidth = 3.0
            return renderer
    }

}

