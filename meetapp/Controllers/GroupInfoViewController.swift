//
// Created by Shai Liberman on 19/04/2020.
// Copyright (c) 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class GroupInfoViewController : UIViewController {
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var membersView: UIView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var city: UILabel!

    var group: Group? {
        didSet {
            groupName.text = group?.name
            subject.text = group?.topic
            level.text = group?.level
            city.text = group?.city
            for child in children {
                if let controller = child as? MembersAreaViewController {
                    guard let group = group else {
                        return
                    }

                    DB.shared.users.getUsersOfGroup(group, onComplete: {(users: [User]) in
                        controller.members = users
                    })
                    break
                }
            }
        }
    }
    
}
