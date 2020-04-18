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
            // reload data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
