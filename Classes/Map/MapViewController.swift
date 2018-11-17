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
import FirebaseFirestore

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private var userTrackingButton: MKUserTrackingButton!
    private let locationManager = CLLocationManager()
    
    let regionInMeters: Double = 15000
    var businesses: [Business] = []
    let tableController = BusinessDetailTableDelegate()
    
    
    
    private func setupNavigationBar() {

    }
    
    private func setupUserTrackingButton() {
        mapView.showsUserLocation = true
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.layer.backgroundColor = UIColor.translucentButtonColor?.cgColor
        userTrackingButton.layer.borderColor = UIColor.white.cgColor
        userTrackingButton.layer.borderWidth = 1
        userTrackingButton.layer.cornerRadius = 5
        userTrackingButton.isHidden = true // Unhides when location authorization is given.
        view.addSubview(userTrackingButton)
        
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([userTrackingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                                     userTrackingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }
    
    private func loadBusinesses() {
//        FirebaseManager.getBusinesses { (businesses) in
//            self.businesses = businesses
//            self.setupAnnotations()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        setupNavigationBar()
        setupUserTrackingButton()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        loadBusinesses()
        
        
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

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let locationAuthorized = status == .authorizedWhenInUse
        userTrackingButton.isHidden = !locationAuthorized
    }
}
