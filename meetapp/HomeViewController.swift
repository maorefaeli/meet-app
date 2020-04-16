//
//  HomeViewController.swift
//  meetapp
//
//  Created by admin on 11/03/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var lblWelcome: UILabel!
    
    var ref:DatabaseReference?
    var uid = ""
    var name = ""
    var user = User.init()
    var groups: [Group] = []
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
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
        ref = Database.database().reference()
        self.ref?.child("groups").observe(.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let groupDict = snap.value as! [String: Any]
                let groupElement: Group = Group(guid: groupDict["guid"] as! String, uid: groupDict["owner"] as! String,
                                                name: groupDict["name"] as! String, level: groupDict["level"] as! String,
                                                city: groupDict["city"] as! String, topic: groupDict["topic"] as! String)//, members: groupDict[""])
                self.groups.append(groupElement)
                print(self.groups[0].uid)
            }
        }
        groupsCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "homeGroupCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.groups.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeGroupCell", for: indexPath) as! CollectionViewCell
        
        cell.lblName.text = self.groups[indexPath.row].name
        cell.lblTopic.text = self.groups[indexPath.row].topic
        cell.lblLevel.text = self.groups[indexPath.row].level
        cell.lblCity.text = self.groups[indexPath.row].city
        
        return cell
    }
}
