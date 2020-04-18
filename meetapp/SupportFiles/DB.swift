//
//  DB.swift
//  meetapp
//
//  Created by Maor Refaeli on 16/04/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import FirebaseDatabase

class DB {
    
    static let shared = DB()

    class Collection {
        let collection:DatabaseReference
        init(_ ref:DatabaseReference, name: String) {
            collection = ref.child(name)
        }
    }
    
    class Users: Collection {
        init(_ ref: DatabaseReference) {
            super.init(ref, name:"users")
        }

        func get(_ uid: String, completion: @escaping (User) -> Void) {
            collection.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let user:User = User()
                user.uid = uid
                if let value = snapshot.value as? NSDictionary {
                    user.name = value["name"] as? String ?? ""
                    user.imageURL = value["userPhoto"] as? String ?? ""
                }
                completion(user)
            })
        }
        
        func update(_ user: User) {
            collection.child(user.uid).setValue(["name": user.name, "userPhoto": user.imageURL])
        }
    }
    
    class Groups: Collection {
        init(_ ref: DatabaseReference) {
            super.init(ref, name:"groups")
        }
        
        func create(_ group: Group) {
            collection.child(group.guid).setValue([
                "guid": group.guid,
                "owner": group.uid,
                "name": group.name,
                "level": group.level,
                "city": group.city,
                "topic": group.topic
            ])
        }
    }
        
    let users:Users
    let groups:Groups
    
    private init() {
        let ref = Database.database().reference()
        users = Users(ref)
        groups = Groups(ref)
    }
}
