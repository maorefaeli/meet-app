//
// Created by Shai Liberman on 18/04/2020.
// Copyright (c) 2020 admin. All rights reserved.
//

import Foundation
import UIKit

public class GroupCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupSubject: UILabel!
    @IBOutlet weak var groupLevel: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var membersString: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var membersArea: MembersAreaViewController!
    @IBOutlet weak var joinButton: UIButton!
    
    var group: Group! {
        didSet {
            groupName.text = group.name
            groupSubject.text = group.topic
            groupLevel.text = group.level
            city.text = group.city
            DB.shared.users.getUsersOfGroup(group, onComplete: {(users: [User]) in
                self.membersArea.members = users
            })
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
            joinButton.addGestureRecognizer(tapGesture)
        }
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    @objc func tap() {
        print("add user to group")
        group.members.append(Configuration.getUserId()!)
        DB.shared.groups.updateMembers(group) { (error:Error?) in
            if error == nil {
                print("user added to group")
            } else {
                print("user could not be added")
            }
        }
    }
}
