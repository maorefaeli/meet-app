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
    
    var ref:DatabaseReference?
    
    func getGroupByName(groupname: String) -> Bool {
        var res = false
        //  Setup firebase database
        ref = Database.database().reference()
        ref?.child("groups").child(groupname).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get group value
          let value = snapshot.value as? NSDictionary
          if value == nil {
            res = false
          } else {
            res = true
            // create the alert
            let alert = UIAlertController(title: "Cannot create a new group", message: "Group name already exist", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            }
          }) { (error) in
            print(error.localizedDescription)
        }
        return res
    }
    
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
        DB.shared.groups.create(group)
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
