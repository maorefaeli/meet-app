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
    var groups: [Group] = []
    var filteredGroups: [Group] = []

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        DB.shared.groups.observeAll(onSuccess: { (groups:[Group]) in
            self.groups = groups
            self.filter(by: "")
        })
    }
    
    // Called from HomeViewController
    func filter(by: String) {
        let filter = by.lowercased()

        if !by.isEmpty {
            filteredGroups = groups.filter{ $0.name.lowercased().contains(filter) }
        } else {
            filteredGroups = groups
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
