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
    var owner: String = ""
    var name: String = ""
    var level: String = ""
    var city: String = ""
    var topic: String = ""
    var long: String = ""
    var lat: String = ""
    var members: [String] = []
    
    // Default Constructor (No parameter)
    var members: [String] = []

    init()  {
    }

    init (guid: String = "", owner: String, name: String, level: String, city: String, topic: String, long: String, lat: String, members: [String]) {
        self.guid = guid
        self.owner = owner
        self.name = name
        self.city = city
        self.level = level
        self.topic = topic
        self.long = long
        self.lat = lat
        self.members = members
    }
 
    func generateGuid() {
        guid = UUID().uuidString
    }
}
