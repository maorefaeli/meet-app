//
// Created by Shai Liberman on 18/04/2020.
// Copyright (c) 2020 admin. All rights reserved.
//

import Foundation
import UIKit

class MemberCell : UICollectionViewCell{
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    
    var member: User! {
        didSet {
            memberImage.image = UIImage(contentsOfFile: member.imageURL)
            memberName.text = member.name
        }
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}
