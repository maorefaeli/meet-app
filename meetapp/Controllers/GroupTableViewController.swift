//
// Created by Shai Liberman on 18/04/2020.
// Copyright (c) 2020 admin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class GroupsTableViewController: UITableViewController {
    let cellHeight: CGFloat = 140
    var ref:DatabaseReference?
    var groups: [Group] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.cellHeight
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
        cell.group = self.groups[indexPath.row]

        return cell
    }
}
