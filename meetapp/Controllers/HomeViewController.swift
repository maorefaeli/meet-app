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
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var groupsContainer: UIView!
    @IBOutlet weak var searchInput: UITextField!

    var groupsController: GroupsTableViewController? = nil
    var groups: [Group] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalPresentationStyle = .fullScreen
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let groups = segue.destination as? GroupsTableViewController {
            self.groupsController = groups
        }
    }
    
    @IBOutlet weak var groupsCollectionView: UICollectionView!
    func getUserById(uid: String) {
        DB.shared.users.get(
            uid,
            onSuccess: { (user:User) in
                self.lblWelcome.text = "Welcome, \(user.name)"
            },
            onError: { (error:Error) in
                print(error.localizedDescription)
                self.performSegue(withIdentifier: "homeToProfile", sender: Any?.self)
            }
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = UserDefaults.standard
        let uidkey = "uid"
        if preferences.object(forKey: uidkey) == nil {
            //  Doesn't exist
        } else {
            let uid = preferences.string(forKey: uidkey)
            self.getUserById(uid: uid!)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        searchButton.addGestureRecognizer(tapGesture)
    }

    @objc func tap() {
        guard let input = searchInput.text else {
            return
        }

        groupsController?.filter(by: input)
    }
}
