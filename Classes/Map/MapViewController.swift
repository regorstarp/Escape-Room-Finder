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
    private var infoButton: UIButton!
    private var separatorView: UIView!
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
    
    lazy private var filterViewController: FilterViewController = {
        let vc = FilterViewController()
        vc.delegate = self
        return vc
    }()
    
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
                if let model = Room(dictionary: document.data(), documentId: document.documentID) {
                    return model
                }
                else {
                    fatalError("Unable to initialize type \(Room.self) with dictionary \(document.data()) ")
                }
            }
            self.rooms = models
            self.documents = snapshot.documents
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.setupAnnotations()
        }
    }
    
    fileprivate func stopObserving() {
        listener?.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(true, animated: false)
        observeQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: false)
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
    
    private func setupButtonsStackView() {
        mapView.showsUserLocation = true
        
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.isHidden = true // Unhides when location authorization is given.
        
        infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(onFilterButtonPressed), for: .touchUpInside)
        infoButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        separatorView = UIView()
        separatorView.isHidden = true
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .gray
        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [infoButton, separatorView, userTrackingButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        
        contentView.layer.backgroundColor = #colorLiteral(red: 0.9725075364, green: 0.9698851705, blue: 0.9590129256, alpha: 1)
//        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 5
        
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.masksToBounds = false
        
        view.addSubview(contentView)
        contentView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
            ])
    }
    
    @objc private func onFilterButtonPressed() {
        present(UINavigationController(rootViewController: filterViewController), animated: true)
    }
    
    private func registerAnnotationViewClasses() {
        mapView.register(RoomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    private func configureFilterButton() {
        let filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(onFilterButtonPressed))
        navigationItem.rightBarButtonItem = filterButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        query = baseQuery()
        title = "Escape Rooms"
        mapView.delegate = self
        mapView.showsCompass = false
        setupButtonsStackView()
        configureFilterButton()
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
        
        for room in rooms {
            let coordinate = room.coordinate
            if !mapView.annotations.contains(where: { $0.coordinate.latitude == coordinate.latitude && $0.coordinate.longitude == coordinate.longitude }) {
                addAnnotation(coordinate: coordinate, title: room.name)
            }
            addAnnotation(coordinate: coordinate, title: room.name)
        }
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
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
        
        let roomAnnotationView = RoomAnnotationView(annotation: annotation, reuseIdentifier: RoomAnnotationView.ReuseID)
//        roomAnnotationView.canShowCallout = true
//        let rightButton = UIButton(type: .detailDisclosure)
//        roomAnnotationView.rightCalloutAccessoryView = rightButton
        return roomAnnotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard view is RoomAnnotationView, let coordinate = view.annotation?.coordinate else { return }
        
        let sameCoordinateRooms = rooms.filter { (room) -> Bool in
            return room.coordinate.latitude == coordinate.latitude && room.coordinate.longitude == coordinate.longitude
        }
        pushDetailViewController(rooms: sameCoordinateRooms)
        
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        guard let coordinate = view.annotation?.coordinate else { return }
//        let sameCoordinateRooms = rooms.filter { (room) -> Bool in
//            return room.coordinate.latitude == coordinate.latitude && room.coordinate.longitude == coordinate.longitude
//        }
//        pushDetailViewController(rooms: sameCoordinateRooms)
//    }
    
    func pushDetailViewController(rooms: [Room]) {
        if rooms.count == 1 {
            guard let room = rooms.first else { return }
            let vc = EscapeRoomDetailViewController()
            let documentIds = DocumentIds.init(business: room.businessId, room: room.documentId)
            vc.documentIds = documentIds
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = BusinessDetailViewController()
            vc.rooms = rooms
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let locationAuthorized = status == .authorizedWhenInUse
        userTrackingButton.isHidden = !locationAuthorized
        separatorView.isHidden = !locationAuthorized
    }
}

extension MapViewController: FilterViewControllerDelegate {
    
    func query(withCategory category: String?, city: String?, difficulty: Int?) -> Query {
        var filtered = baseQuery()
        
        if let category = category, !category.isEmpty {
            filtered = filtered.whereField("categories", arrayContains: category)
        }
        
        if let city = city, !city.isEmpty {
            filtered = filtered.whereField("city", isEqualTo: city)
        }
        
        if let difficulty = difficulty {
            filtered = filtered.whereField("difficulty", isEqualTo: difficulty)
        }
        
//        if let sortBy = sortBy, !sortBy.isEmpty {
//            filtered = filtered.order(by: sortBy)
//        }
        
        // Advanced queries
        
        return filtered
    }
    
    func controller(_ controller: FilterViewController, didSelectCategory category: String?, city: String?, difficulty: Int?) {
        let filtered = query(withCategory: category, city: city, difficulty: difficulty)
        
        query = filtered
        observeQuery()
    }
}
