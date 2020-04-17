//
// Created by Shai Liberman on 11/04/2020.
// Copyright (c) 2020 admin. All rights reserved.
//

import Foundation
import UIKit

public class GroupCell: UITableViewCell {
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupSubject: UILabel!
    @IBOutlet weak var groupLevel: UILabel!
    @IBOutlet weak var city: UILabel!
  
    var group: Group! {
        didSet {
            groupName.text = group.name
            groupSubject.text = group.topic
            groupLevel.text = group.level
            city.text = group.city
        }
    }

    func setGroup(group: Group) {
        groupName.text = group.name
        groupSubject.text = group.topic
        groupLevel.text = group.level
        city.text = group.city
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}
