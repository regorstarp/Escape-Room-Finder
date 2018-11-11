//
//  MapViewController.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 10/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userTrackingButtonContentView: UIView!
    @IBOutlet weak var filterButtonContentView: UIView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 6000
    var directionsArray: [MKDirections] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupLocateButton()
        setupFilterButton()
        checkLocationServices()
        setupAnotations()
    }
    
    func setupAnotations() {
        guard let location = locationManager.location?.coordinate else { return }
        
        let anotation = MKPointAnnotation()
        anotation.title = "Home"
        anotation.coordinate = location
        self.mapView.addAnnotation(anotation)
        
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString("josep renom 105, sabadell") { (placemarks, error) in
//            guard
//                let placemarks = placemarks,
//                let location = placemarks.first?.location
//                else {
//                    // handle no location found
//                    return
//            }
//
//            // Use your location
//
//            let anotation = MKPointAnnotation()
//            anotation.title = "Home"
//            anotation.coordinate = location.coordinate
//            self.mapView.addAnnotation(anotation)
//        }
    }
    
    private func setupLocateButton() {
        let locationView = MKUserTrackingButton(mapView: mapView)
        locationView.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin]
        locationView.frame = userTrackingButtonContentView.bounds
        userTrackingButtonContentView.addSubview(locationView)
        setupButtonContentView(for: userTrackingButtonContentView)

    }
    
    private func setupFilterButton() {
        let filterButton = UIButton(type: .infoLight)
        filterButton.frame = filterButtonContentView.bounds
        filterButtonContentView.addSubview(filterButton)
        setupButtonContentView(for: filterButtonContentView)
    }
    
    private func setupButtonContentView(for view: UIView) {
        view.layer.borderColor = UIColor(white: 0.2, alpha: 0.2).cgColor
        view.backgroundColor = UIColor(hue: 0.13, saturation: 0.03, brightness: 0.97, alpha: 1.0)
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.1
    }
    
    @objc func onCenterLocationButton() {
        centerViewOnUserLocation()
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            showAlert(title: "Location permission", message: "The app needs location access allowed to function properly")
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            
            showAlert(title: "Location permission", message: "The app needs location access allowed to function properly")
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAlert(title: "Location permission", message: "The app needs location access allowed to function properly")
        case .authorizedAlways:
            break
        }
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
    }
    
//    let coordinate = CLLocationCoordinate2DMake(theLatitude,theLongitude)
//    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
//    mapItem.name = "Target location"
//    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            let markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            markerAnnotationView.glyphText = "Test"
            annotationView = markerAnnotationView
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        tabBarController?.tabBar.isHidden = true
        let roomDetailViewController = RoomDetailViewController()
        let nc = UINavigationController(rootViewController: roomDetailViewController)
        nc.definesPresentationContext = true
        nc.modalTransitionStyle = .coverVertical
        nc.modalPresentationStyle = .overCurrentContext
        nc.isNavigationBarHidden = true
        present(nc, animated: true)
    }
}
