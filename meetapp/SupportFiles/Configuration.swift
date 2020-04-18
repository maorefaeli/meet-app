//
//  Configuration.swift
//  meetapp
//
//  Created by Maor Refaeli on 18/04/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class Configuration {
    private static let preferences = UserDefaults.standard
    
    private static let USER_ID = "uid"
    
    static func saveUserId(_ id:String) {
        preferences.set(id, forKey: USER_ID)
    }
    
    static func getUserId() -> String? {
        return preferences.string(forKey: USER_ID)
    }
}
