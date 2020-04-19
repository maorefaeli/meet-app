//
//  LocalDB.swift
//  meetapp
//
//  Created by admin on 19/04/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import FirebaseDatabase
import SQLite3

class LocalDB {
            
    static func isLoggedIn () -> Bool {
        var db: OpaquePointer?
        var readSTMNT: OpaquePointer?
        let fileURL = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("myGroups.sqlite")
        sqlite3_open(fileURL.path, &db)
        let readQuery = "SELECT uid from Uids"
        sqlite3_prepare(db, readQuery, -1, &readSTMNT, nil)
        while (sqlite3_step(readSTMNT) == SQLITE_ROW) {
            guard let queryResultCol1 = sqlite3_column_text(readSTMNT, 0) else {
              print("Query result is nil")
              return false
            }
            let uid = String(cString: queryResultCol1)
            print(uid)
            if uid != nil {
                return true
            } else {
                return false
            }
        }
        return false
    }
}

