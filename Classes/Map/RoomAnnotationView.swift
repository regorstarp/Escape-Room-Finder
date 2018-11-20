//
//  RoomAnnotationView.swift
//  Escape Room Finder
//
//  Created by Roger Prats on 20/11/2018.
//  Copyright © 2018 Roger Prats. All rights reserved.
//

import MapKit

class RoomAnnotationView: MKMarkerAnnotationView {
    static  let ReuseID = "roomAnnotation"
    
    /// - Tag: ClusterIdentifier
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "room"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        tintColor = UIColor.roomButtonColor
        glyphImage = #imageLiteral(resourceName: "lock")
    }
}
