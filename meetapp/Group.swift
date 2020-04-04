//
//  Group.swift
//  meetapp
//
//  Created by admin on 04/04/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class Group {
    var uid: String = ""
    var name: String = ""
    var level: String = ""
    var city: String = ""
    var topic: String = ""
    
    // Default Constructor (No parameter)
    init()  {
         
    }
     
    init (uid: String, name: String, level: String, city: String, topic: String)  {
        self.uid = uid
        self.name = name
        self.city = city
        self.level = level
        self.topic = topic
    }
     
}
