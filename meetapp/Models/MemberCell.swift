//
// Created by Shai Liberman on 18/04/2020.
// Copyright (c) 2020 admin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class MemberCell : UICollectionViewCell{
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    
    var member: User! {
        didSet {
            if member.imageURL.isEmpty {
                memberImage.image = UIImage(named: "Logo")
            } else {
                self.getImage(url: member.imageURL) { (image) in
                    self.memberImage.image = image
                }
            }
            memberName.text = member.name
        }
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    func getImage(url:String, callback:@escaping (UIImage?)->Void) {
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
}
