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
import FirebaseAuth
import FirebaseUI

class MapViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    @IBOutlet weak var mapView: MKMapView!
    private var userTrackingButton: MKUserTrackingButton!
    private let locationManager = CLLocationManager()
    private let authUI = FUIAuth.defaultAuthUI()!
    
    private let regionInMeters: Double = 15000
    private var businesses: [Business] = []
    
    private var rooms: [Room] = []
    private var documents: [DocumentSnapshot] = []
    
    fileprivate var query: Query? {
        didSet {
            if let listener = listener {
                listener.remove()
                observeQuery()
            }
        }
    }
    
    private var listener: ListenerRegistration?
    
    fileprivate func observeQuery() {
        guard let query = query else { return }
        stopObserving()
        
        // Display data from Firestore, part one
        listener = query.addSnapshotListener { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error feching snapshot results: \(error!)")
                return
            }
            let models = snapshot.documents.map { (document) -> Room in
                if let model = Room(dictionary: document.data()) {
                    return model
                }
                else {
                    fatalError("Unable to initialize type \(Room.self) with dictionary \(document.data()) ")
                }
            }
            self.rooms = models
            self.documents = snapshot.documents
            self.setupAnnotations()
        }
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        observeQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        stopObserving()
    }
    
    deinit {
        listener?.remove()
    }
    
    fileprivate func baseQuery() -> Query {
        // Firestore needs to use Timestamp type instead of Date type.
        // https://firebase.google.com/docs/reference/swift/firebasefirestore/api/reference/Classes/FirestoreSettings
        let firestore: Firestore = Firestore.firestore()
        let settings = firestore.settings
        settings.areTimestampsInSnapshotsEnabled = true
        settings.isPersistenceEnabled = false // cache
        firestore.settings = settings
        return firestore.collection("room")
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
    
    private func registerAnnotationViewClasses() {
        mapView.register(RoomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        query = baseQuery()
        
        mapView.delegate = self
        setupUserTrackingButton()
        registerAnnotationViewClasses()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let coordinate = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func setupAnnotations() {
        for index in rooms.indices {
            let room = rooms[index]
            let coordinate = room.coordinate
            if !mapView.annotations.contains(where: { $0.coordinate.latitude == coordinate.latitude && $0.coordinate.longitude == coordinate.longitude }) {
                addAnnotation(coordinate: coordinate, index: index)
            }
        }
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, index: Int) {
        let annotation = CustomMKPointAnnotation()
        annotation.index = index
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
}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        return RoomAnnotationView(annotation: annotation, reuseIdentifier: RoomAnnotationView.ReuseID)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is RoomAnnotationView else { return }
        let coordinate = view.annotation!.coordinate
        let sameCoordinateRooms = rooms.filter { (room) -> Bool in
            return room.coordinate.latitude == coordinate.latitude && room.coordinate.longitude == coordinate.longitude
        }
        
        let vc = BusinessDetailViewController()
        vc.rooms = sameCoordinateRooms
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showBusiness(_ business: Business, businessId: String) {
        let business = business
        let roomRef = Firestore.firestore().collection("room").whereField("businessId", isEqualTo: businessId)
        roomRef.getDocuments { [unowned self] (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error feching snapshot results: \(error!)")
                return
            }
            
            let rooms = snapshot.documents.map { (document) -> Room in
                if let model = Room(dictionary: document.data()) {
                    return model
                }
                else {
                    fatalError("Unable to initialize type \(Room.self) with dictionary \(document.data()) ")
                }
            }
            let vc = BusinessDetailViewController()
            vc.business = business
            vc.rooms = rooms
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let locationAuthorized = status == .authorizedWhenInUse
        userTrackingButton.isHidden = !locationAuthorized
    }
}

class CustomMKPointAnnotation: MKPointAnnotation {
    var index: Int!
}

