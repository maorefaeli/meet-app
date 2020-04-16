//
//  Group.swift
//  meetapp
//
//  Created by admin on 04/04/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class Group {
    var guid: String = ""
    var uid: String = ""
    var name: String = ""
    var level: String = ""
    var city: String = ""
    var topic: String = ""
    //var members: [String] = []
    
    // Default Constructor (No parameter)
    init()  {
         
    }
    
    init (guid: String = "", uid: String, name: String, level: String, city: String, topic: String/*, members: [String]*/)  {
        self.guid = guid
        self.uid = uid
        self.name = name
        self.city = city
        self.level = level
        self.topic = topic
        //self.members = members
    }
 
    func generateGuid() {
        guid = UUID().uuidString
    }
}
