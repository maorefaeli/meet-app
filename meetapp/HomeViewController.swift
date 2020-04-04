//
//  HomeViewController.swift
//  meetapp
//
//  Created by admin on 11/03/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeViewController: UIViewController {

    @IBOutlet var lblWelcome: UILabel!
    
    var ref:DatabaseReference?
    var uid = ""
    var name = ""
    var user = User.init()
    
    func getUserUserById(uid: String) {
        //  Setup firebase database
        ref = Database.database().reference()
        ref?.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get profile value
          let value = snapshot.value as? NSDictionary
          if value == nil {
            self.performSegue(withIdentifier: "homeToProfile", sender: Any?.self)
          } else {
            self.user = User.init(uid: uid, name: value?["name"] as? String ?? "")
            self.lblWelcome.text = "Welcome, \(self.user.name)"
            }
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = UserDefaults.standard
        let uidkey = "uid"
        if preferences.object(forKey: uidkey) == nil {
            //  Doesn't exist
        } else {
            let uid = preferences.string(forKey: uidkey)
            getUserUserById(uid: uid!)
        }
    }
}
