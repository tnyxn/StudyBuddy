//
//  MarkerInfoViewController.swift
//  StudyBuddy
//
//  Created by Tony Nguyen on 2016-12-08.
//  Copyright © 2016 Tony N. All rights reserved.
//

import UIKit
import GoogleMaps

class MarkerInfoViewController: UIViewController {
    
    var currentMarker: PlaceMarker?
    
    init(marker: PlaceMarker) {
        self.currentMarker = marker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var placeImage = UIImageView()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.02, green:0.55, blue:1.00, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.title = currentMarker!.place.name
        
        print("\(currentMarker!.place.name)")
        print("\(currentMarker!.place.placeType)")
        if let ref = currentMarker!.place.photoReference as String? {
            print("\(ref)")
        }
        
        print("\(currentMarker!.place.photo)")
        
        
        let close = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: #selector(closeWindow))
        self.navigationItem.leftBarButtonItem = close
        
        view.backgroundColor = UIColor.whiteColor()
        
    }
    
    static func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData {
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
    func closeWindow() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
