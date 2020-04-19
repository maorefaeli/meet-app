//
//  MapAnnotation.swift
//  meetapp
//
//  Created by Maor Refaeli on 19/04/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let group:Group

    init(group: Group, coordinate: CLLocationCoordinate2D) {
        self.title = "\(group.name) (\(group.city))"
        self.subtitle = "\(group.topic) - \(group.level)"
        self.coordinate = coordinate
        self.group = group
        
        super.init()
    }
}
