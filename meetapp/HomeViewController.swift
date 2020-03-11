//
//  HomeViewController.swift
//  meetapp
//
//  Created by admin on 11/03/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore

class HomeViewController: UIViewController {

    @IBOutlet var lblWelcome: UILabel!
    
    let database = Firestore.firestore()
    
    var uid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let preferences = UserDefaults.standard

        let uidkey = "uid"

        if preferences.object(forKey: uidkey) == nil {
            //  Doesn't exist
        } else {
            let uid = preferences.string(forKey: uidkey)
            self.lblWelcome.text = "Welcome, \(String(describing: uid))"
        }
        //  this is how to add new document
        //  self.database.collection("profiles").addDocument(data: ["year":2017, "type":"cab", "label":"something"])
        let profiles = self.database.collection("profiles").whereField("uid", isEqualTo: self.uid)
        if profiles == nil {
            performSegue(withIdentifier: "homeToProfile", sender: Any?.self)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
