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
import SQLite3

class LoginController: UIViewController {
    
    @IBOutlet weak var teEmail: UITextField!
    @IBOutlet weak var tePassword: UITextField!
    //@IBOutlet var tbEmail: UITextField!
    //@IBOutlet var tbPassword: UITextField!
    @IBOutlet weak var tbStatus: UILabel!
    
    var userGroups: [Group] = []

    func getUserGroups(uid: String) {
        DB.shared.groups.observeAll(onSuccess: { (groups:[Group]) in
            self.userGroups = []
            for group in groups {
                if group.members.contains(uid) {
                    self.userGroups.append(group)
                }
            }
       })
    }
        
    func saveUserAndGoHome() {
        let uid = Auth.auth().currentUser!.uid
        Configuration.saveUserId(uid)
        
        var db: OpaquePointer?
        var stmnt: OpaquePointer?
        let fileURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("myGroups.sqlite")
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            Helper.showToast(controller: self, message: "Error loading local data", seconds: 5)
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Groups (id INTEGER PRIMARY KEY AUTOINCREMENT, guid TEXT)"
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            Helper.showToast(controller: self, message: "Error loading local data", seconds: 5)
        }
        
        let insertQuery = "INSERT INTO Groups (guid) VALUES (?)"
        if sqlite3_prepare(db, insertQuery, -1, &stmnt, nil) != SQLITE_OK {
            Helper.showToast(controller: self, message: "Error loading local data", seconds: 5)
        }
        self.getUserGroups(uid: uid)
        for userGroup in userGroups {
            if sqlite3_bind_text(stmnt, 1, userGroup.guid, -1, nil) != SQLITE_OK {
                Helper.showToast(controller: self, message: "Error loading local data", seconds: 5)
                return
            }
            if sqlite3_step(stmnt) != SQLITE_DONE {
                Helper.showToast(controller: self, message: "Error saving local data", seconds: 5)
                return
            }
            print("Added 1 item")
        }
        
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
            strongSelf.saveUserAndGoHome()
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
            self.saveUserAndGoHome()
        }
    }
}
