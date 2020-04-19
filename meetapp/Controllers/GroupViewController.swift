//
//  GroupViewController.swift
//  meetapp
//
//  Created by admin on 04/04/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class GroupViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var longCoor: String = ""
    var latCoor: String = ""
    
    @IBOutlet var tbGroupName: UITextField!
    @IBOutlet var tbGroupCity: UITextField!
    @IBOutlet var tbTopic: UITextField!
    @IBOutlet var scLevel: UISegmentedControl!
    
    @IBAction func createGroup(_ sender: Any) {
        let uid = Auth.auth().currentUser!.uid
        let group: Group = Group(
            owner: uid,
            name: tbGroupName.text!,
            level: Helper.getLevelAsString(scLevel.selectedSegmentIndex),
            city: tbGroupCity.text!,
            topic: tbTopic.text!,
            long: self.longCoor,
            lat: self.latCoor,
            members: [uid]
        )
        group.generateGuid()
        DB.shared.groups.upsert(group)
        performSegue(withIdentifier: "createGroupToHome", sender: Any?.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        self.longCoor = "\(userLocation!.coordinate.longitude)"
        self.latCoor = "\(userLocation!.coordinate.latitude)"
    }
}
