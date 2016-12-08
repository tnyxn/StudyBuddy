//
//  ViewController.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2016-11-30.
//  Copyright © 2016 Tony N. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class MainViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    var mapView = GMSMapView()
    var label = UILabel()
    
    var didFindMyLocation = false
    
    var searchedTypes = ["cafe", "coffee", "library", "study"]
    let dataProvider = GoogleDataProvider()
    let searchRadius: Double = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Main"
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.02, green:0.55, blue:1.00, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display Toronto coordinates
        let camera = GMSCameraPosition.cameraWithLatitude(43.6532, longitude: -79.3832, zoom: 15.0)
        mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        
        let tabBarHeight = TabBarViewController().tabBar.frame.size.height
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)
        
        mapView.myLocationEnabled = true
        mapView.delegate = self
        self.view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
        marker.map = mapView
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 15.0)
            mapView.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        // 1
        mapView.clear()
        // 2
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius: searchRadius, types: searchedTypes) {
            places in for place: GooglePlace in places {
                // 3
                let marker = PlaceMarker(place: place)
                // 4
                marker.map = self.mapView
            }
        }
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        fetchNearbyPlaces(mapView.camera.target)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            fetchNearbyPlaces(location.coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
}

