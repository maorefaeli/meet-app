//
// Created by Shai Liberman on 18/04/2020.
// Copyright (c) 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class MembersAreaViewController :  UICollectionViewController {
    var members: [User]! {
        didSet {
            self.collectionView.reloadData()
        }
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        members.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! MemberCell
//        cell.member = members[indexPath.row]
//
//        return cell
//    }
}
