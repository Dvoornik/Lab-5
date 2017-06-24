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
    
    var myLockMgr = CLLocationManager()
    var myGeoCoder = CLGeocoder()
    var showPlacemak : CLPlacemark?
    
    var toAddr : String?
    
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
    }

    @IBAction func directions(_ sender: Any) {
    }
}

