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
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var groupsContainer: UIView!
    @IBOutlet weak var searchInput: UITextField!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var mapContainer: UIView!


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
        
        mapContainer.isHidden = true
        listButton.isHidden = true
        let uid = Configuration.getUserId()
        if uid != nil {
            self.getUserById(uid: uid!)
        }
        
        let searchTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSearch))
        searchButton.addGestureRecognizer(searchTapGesture)

        let mapTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMap))
        mapButton.addGestureRecognizer(mapTapGesture)

        let listTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapList))
        listButton.addGestureRecognizer(listTapGesture)
    }

    @objc func tapSearch() {
        guard let input = searchInput.text else {
            return
        }

        groupsController?.filter(by: input)
    }

    @objc func tapMap() {
        groupsContainer.isHidden = true
        mapButton.isHidden = true

        mapContainer.isHidden = false
        listButton.isHidden = false
    }

    @objc func tapList() {
        mapContainer.isHidden = true
        listButton.isHidden = true

        groupsContainer.isHidden = false
        mapButton.isHidden = false
    }
}
