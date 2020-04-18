//
//  Profile.swift
//  meetapp
//
//  Created by admin on 04/04/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class User {
    var uid: String = ""
    var name: String = ""
    var imageURL: String = ""
//    var groupIds: [String] = []
    
    init()  {
    }
     
    init (uid: String, name: String, imageURL: String = "")  {
        self.uid = uid
        self.name = name
        self.imageURL = imageURL
    }
     
}
