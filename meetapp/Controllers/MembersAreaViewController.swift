//
// Created by Shai Liberman on 18/04/2020.
// Copyright (c) 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class MembersAreaViewController : UICollectionView {
    var members: [User]! = [] {
        didSet {
            reloadData()
        }
    }
    override var numberOfSections: Int {
        guard let members = members else {
            return 0
        }

        return members.count
    }

    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCell
        cell.member = members?[indexPath.row]

        return cell
    }
}
