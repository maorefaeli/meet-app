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
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var joinText: UILabel!
    @IBOutlet weak var openInfoButton: UIButton!
    var isMyGroup = false
    
    var group: Group! {
        didSet {
            if isMyGroup {
                joinButton.isHidden = true
                joinText.isHidden = true
            }
            groupName.text = group.name
            groupSubject.text = group.topic
            groupLevel.text = group.level
            city.text = group.city

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
            joinButton.addGestureRecognizer(tapGesture)

            let openInfoGesture = UITapGestureRecognizer(target: self, action: #selector(openInfo))
            openInfoButton.addGestureRecognizer(openInfoGesture)
        }
    }

    var openInfoCallback: (() -> Void)?
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    @objc func tap() {
        print("add user to group")
        group.members.append(Configuration.getUserId()!)
        DB.shared.groups.upsert(group) { (error:Error?) in
            if error == nil {
                print("user added to group")
            } else {
                print("user could not be added")
            }
        }
    }

    @objc func openInfo() {
        self.openInfoCallback?()
    }
}
