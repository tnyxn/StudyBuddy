//
//  ViewController.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2016-11-30.
//  Copyright © 2016 Tony N. All rights reserved.
//

import UIKit
import MMDrawerController
import GooglePlaces
import GoogleMaps

class MainViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Study Buddy"
        
        let btn = UIBarButtonItem(title: "Menu", style: .Plain, target: self, action: "SideMenuButtonTapped:")
        self.navigationItem.leftBarButtonItem = btn
        
        let search = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = search
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.02, green:0.55, blue:1.00, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.myLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    func SideMenuButtonTapped(sender: UIBarButtonItem) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }


}

