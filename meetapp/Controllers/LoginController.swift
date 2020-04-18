//
//  ViewController.swift
//  meetapp
//
//  Created by admin on 11/03/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseAuth

class LoginController: UIViewController {
    
    @IBOutlet var teEmail: UITextField!
    @IBOutlet var tePassword: UITextField!
    

    //@IBOutlet var tbEmail: UITextField!
    //@IBOutlet var tbPassword: UITextField!
    @IBOutlet var tbStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func saveUidToPreferences() {
        let preferences = UserDefaults.standard
        let uidkey = "uid"
        let uid = Auth.auth().currentUser!.uid
        preferences.set(uid, forKey: uidkey)
        //  Save to disk
        let didSave = preferences.synchronize()
        print("Saved:", didSave)
        performSegue(withIdentifier: "goHome", sender: Any?.self)
    }
    @IBAction func loginAction(_ sender: Any) {
        let email = teEmail.text!
        let password = tePassword.text!
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let strongSelf = self else { return }
            if (error != nil) {
                strongSelf.tbStatus.text = "Error, check email and password and try again"
                print(error!)
                return
            }
            strongSelf.tbStatus.text = "Succesful login for email \(email)!"
            strongSelf.saveUidToPreferences()
        }
    }
    @IBAction func registerAction(_ sender: Any) {
        let email = teEmail.text!
        let password = tePassword.text!
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if(error != nil) {
                self.tbStatus.text = "Error"
                print(error!)
                return
            }
            self.tbStatus.text = "User created!"
            self.saveUidToPreferences()
        }
    }
}
