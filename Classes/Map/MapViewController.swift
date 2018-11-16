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
    var businesses: [Business] = []
    let tableController = BusinessDetailTableDelegate()
    
    private var closedTransform = CGAffineTransform.identity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupLocateButton()
        setupFilterButton()
        checkLocationServices()
        FirebaseManager.getBusinesses { (businesses) in
            self.businesses = businesses
            self.setupAnnotations()
        }
        navigationController?.tabBarController?.tabBar.isHidden = true
        
    }
    
    func setupAnnotations() {
        for business in businesses {
            getCoordinate(addressString: business.address) { (coordinate, error) in
//                guard error != nil else { return } //to ignore wrong coordinate
                self.addAnnotation(coordinate: coordinate, name: business.name)
            }
        }
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, name: String) {
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
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
        
//        getCoordinate(addressString: "Carrer de Casp, 9 08204 SABADELL") { (coordinate, error) in
//            print(coordinate)
//        }
    }
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: self.regionInMeters, longitudinalMeters: self.regionInMeters)
                    self.mapView.setRegion(region, animated: true)
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    private lazy var drawerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
        }()
    
    private lazy var drawerNavigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.layer.cornerRadius = 8
        
        let titleItem = UINavigationItem(title: "")
        let doneButton = UIButton(type: .roundedRect)
        doneButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        doneButton.setTitle("Done", for: .normal)
        doneButton.backgroundColor = #colorLiteral(red: 0.8521460295, green: 0.8940392137, blue: 0.9998423457, alpha: 1)
        doneButton.layer.cornerRadius = 10
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        titleItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        navBar.setItems([titleItem], animated: false)
        
        return navBar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    
    @objc private func done() {
        drawerView.removeFromSuperview()
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
    }
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
//            markerAnnotationView.glyphText = annotation.title ?? ""
            annotationView = markerAnnotationView
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

//        guard let location = view.annotation?.coordinate else { return }
//        mapView.setCenter(location, animated: true)
        
        self.view.addSubview(drawerView)
        
        NSLayoutConstraint.activate([
//            drawerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 80),
            drawerView.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.4),
            drawerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10),
            drawerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            drawerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        
        drawerView.addSubview(drawerNavigationBar)
        
        NSLayoutConstraint.activate([
            drawerNavigationBar.topAnchor.constraint(equalTo: drawerView.topAnchor),
            drawerNavigationBar.leadingAnchor.constraint(equalTo: drawerView.leadingAnchor),
            drawerNavigationBar.trailingAnchor.constraint(equalTo: drawerView.trailingAnchor)
            ])
        
        
        
        if case let annotationTitle?? = view.annotation?.title {
            drawerNavigationBar.topItem?.title = annotationTitle
            FirebaseManager.getBusiness(withName: annotationTitle) { (business) in
                self.setupTableView(forBusiness: business)
            }
        }
        
//        closedTransform = CGAffineTransform(translationX: 0, y: self.view.bounds.height * 0.4)
//        drawerView.transform = closedTransform
    }
    
    private func setupTableView(forBusiness business: Business) {
        drawerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: drawerNavigationBar.bottomAnchor, constant: 6),
            tableView.leadingAnchor.constraint(equalTo: drawerNavigationBar.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: drawerNavigationBar.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: drawerView.bottomAnchor)
            ])
        
        tableController.business = business
        tableView.delegate = tableController
        tableView.dataSource = tableController
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        drawerNavigationBar.topItem?.title = ""
        drawerView.removeFromSuperview()
    }
}

extension MapViewController: DrawerViewControllerDelegate {
    func dismiss() {
        presentedViewController?.dismiss(animated: true)
        mapView.selectedAnnotations = []
    }
}
