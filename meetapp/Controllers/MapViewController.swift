//
// Created by Shai Liberman on 18/04/2020.
// Copyright (c) 2020 admin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    @IBOutlet var map: MKMapView!

    var groups: [Group] = [] {
        didSet {
            showGroups()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showGroups() {
        map.removeAnnotations(map.annotations)

        for group in groups {
            guard let lat = CLLocationDegrees(group.lat), let long = CLLocationDegrees(group.long) else {
                return
            }

            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let pin = MKPlacemark(coordinate: coordinate)
            let coordinateRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
            map.setRegion(coordinateRegion, animated: true)
            map.addAnnotation(pin)
        }
    }
}
