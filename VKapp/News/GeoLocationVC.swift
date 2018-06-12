//
//  GeoLocationVC.swift
//  VKapp
//
//  Created by Didar Naurzbayev on 5/14/18.
//  Copyright © 2018 Didar Naurzbayev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMobileAds

class GeoLocationVC: UIViewController, CLLocationManagerDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var lat = 0.0
    var long = 0.0
    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        navigationBarSetUp()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            
            
            lat = currentLocation.latitude
            long = currentLocation.longitude
            
            let coordinate = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            let coder = CLGeocoder()
            coder.reverseGeocodeLocation(coordinate) {(myPlaces,Error) -> Void in
            }
            let currentRadius: CLLocationDistance = 500
            let currentRegion = MKCoordinateRegionMakeWithDistance((currentLocation), currentRadius * 2.0, currentRadius * 2.0)
            self.mapView.setRegion(currentRegion, animated: true)
            self.mapView.showsUserLocation = true
        }
    }

    
    func navigationBarSetUp(){
        self.navigationItem.title = "Геолокация"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        }
    }
    
}
