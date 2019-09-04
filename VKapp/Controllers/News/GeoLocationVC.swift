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

private let reuseIdentifer = "locationID"

class GeoLocationVC: UIViewController, CLLocationManagerDelegate{
    
    let mapView = MKMapView()

    var addPostVC = AddMyPost()
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("текущее местоположение", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
        button.titleLabel?.baselineAdjustment = .alignCenters
        button.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        return button
    }()
    
    let locationManager = CLLocationManager()
    var lat = 0.0
    var long = 0.0
    var delegate: AddGeolocationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
 
        view.addSubview(mapView)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 0, height: 0)

        view.addSubview(doneButton)
        doneButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)

        locationManagerConfigurations()
        configureNavigationBar()
    }
    
    func locationManagerConfigurations(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            
            
            lat = currentLocation.latitude
            long = currentLocation.longitude
            
            delegate?.addGeolocation(lat: lat, long: long)
            
            let coordinate = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            let coder = CLGeocoder()
            coder.reverseGeocodeLocation(coordinate) {(myPlaces,Error) -> Void in
            }
            let currentRadius: CLLocationDistance = 500
            let currentRegion = MKCoordinateRegion.init(center: (currentLocation), latitudinalMeters: currentRadius * 2.0, longitudinalMeters: currentRadius * 2.0)
            self.mapView.setRegion(currentRegion, animated: true)
            self.mapView.showsUserLocation = true
        }
    }
    
    @objc func doneAction(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 35, green: 40, blue: 58)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        navigationItem.title = "Моя геолокация"

        
    }
    
}


struct GeoLocation {
    var lat: Double
    var long: Double
}

protocol AddGeolocationDelegate {
    func addGeolocation(lat: Double, long: Double)
}
