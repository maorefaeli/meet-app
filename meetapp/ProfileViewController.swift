//
//  ProfileViewController.swift
//  meetapp
//
//  Created by admin on 11/03/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet var tbName: UITextField!
    var ref:DatabaseReference?
    
    @IBAction func updateProfile(_ sender: Any) {
        var user: User
        user = User.init(uid: Auth.auth().currentUser!.uid, name: tbName.text!)

        ref = Database.database().reference()
        
        ref?.child("users").child(user.uid).setValue(["name": user.name])
        performSegue(withIdentifier: "profileToHome", sender: Any?.self)
    }
    @IBAction func showMyGroups(_ sender: Any) {
        performSegue(withIdentifier: "profileToMygroups", sender: Any?.self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
