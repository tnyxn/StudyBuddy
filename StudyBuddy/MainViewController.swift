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
    
    let locationManager = CLLocationManager()
    
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
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.02, green:0.55, blue:1.00, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Main"
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func loadView() {
        // Create a GMSCameraPosition that tells the map to display Toronto coordinates
        let camera = GMSCameraPosition.cameraWithLatitude(43.6532, longitude: -79.3832, zoom: 15.0)
        mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        
        //Add bottom padding to move Google logo and myLocation button up from behind tab bar
        let tabBarHeight = TabBarViewController().tabBar.frame.size.height
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: tabBarHeight, right: 0)
        
        mapView.myLocationEnabled = true
        view = mapView
        mapView.delegate = self
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832)
        marker.title = "Toronto"
        marker.map = mapView
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
    }
    
    deinit {
        //remove KVO when going to another screen
        mapView.removeObserver(self, forKeyPath: "myLocation", context: nil)
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
        // Clear Map
        mapView.clear()
        // Get nearby places
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius: searchRadius, types: searchedTypes) {places in
            for place: GooglePlace in places {
                // Map Icons
                let marker = PlaceMarker(place: place)
                // Place on Map
                marker.map = self.mapView
            }
        }
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        fetchNearbyPlaces(mapView.camera.target)
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        //Camera pans to tapped marker
        mapView.camera = GMSCameraPosition(target: marker.position, zoom: 15, bearing: 0, viewingAngle: 0)
        
        //Show marker info of tapped marker
        
        let marker = marker as! PlaceMarker
        marker.position = CLLocationCoordinate2D(latitude: marker.position.latitude, longitude: marker.position.longitude)
        marker.title = marker.place.name
        marker.snippet = marker.place.address
        marker.map = mapView
        print("\(marker.place.name)")
        print("\(marker.place.placeType)")
        
        //Display marker info
        let markerInfoView = MarkerInfoViewController(marker: marker)
        let navController = UINavigationController(rootViewController: markerInfoView)
        presentViewController(navController, animated: true, completion: nil)
        
        
        return true
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
            print("authorize!")
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            fetchNearbyPlaces(location.coordinate)
            locationManager.stopUpdatingLocation()
            print("update!")
        }
    }
    
}

