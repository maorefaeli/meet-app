//
// Created by Shai Liberman on 18/04/2020.
// Copyright (c) 2020 admin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class GroupsTableViewController: UITableViewController {
    let cellHeight: CGFloat = 200
    var ref:DatabaseReference?
    var groups: [Group] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var filteredGroups: [Group] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Called from HomeViewController
    func filter(by: String) {
        let filter = by.lowercased()

        // filter: user is not member, if there is filterBy use it
        let userId = Configuration.getUserId() ?? ""
        filteredGroups = groups.filter{ (group:Group) in
            if group.members.contains(userId) {
                return false
            }
            if !by.isEmpty {
                return group.name.lowercased().contains(filter)
            }
            return true
        }

        self.tableView?.reloadData()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.cellHeight
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
        cell.setGroup(group: self.filteredGroups[indexPath.row])

        return cell
    }
}
