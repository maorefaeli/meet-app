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
        map.delegate = self
    }

    func showGroups() {
        map.removeAnnotations(map.annotations)

        for group in groups {
            guard let lat = CLLocationDegrees(group.lat), let long = CLLocationDegrees(group.long) else {
                continue
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            map.addAnnotation(MapAnnotation(group: group, coordinate: coordinate))

            // Display the are of the last point
            let pin = MKPlacemark(coordinate: coordinate)
            let coordinateRegion = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            map.setRegion(coordinateRegion, animated: true)
        }
    }
}

extension MapViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButton.ButtonType.contactAdd)

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        guard let annotation = view.annotation as? MapAnnotation else
        {
            return
        }

        annotation.group.members.append(Configuration.getUserId()!)
        DB.shared.groups.upsert(annotation.group)
    }
}
