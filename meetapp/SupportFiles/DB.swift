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

        func get(_ uid: String, onSuccess: @escaping (User) -> Void) {
            get(uid, onSuccess: onSuccess, onError: nil)
        }
        
        func get(_ uid: String, onSuccess: @escaping (User) -> Void, onError: ((Error) -> Void)?) {
            collection.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    let user = User(uid: uid,
                                    name: value["name"] as? String ?? "",
                                    imageURL: value["userPhoto"] as? String ?? "")
                    onSuccess(user)
                } else {
                    onError?(CustomError.general(desc: "User data is corrupted"))
                }
            }, withCancel: { (error:Error) in
                onError?(error)
            })
        }

        func update(_ user: User, onComplete: ((Error?) -> Void)?) {
            collection.child(user.uid).setValue(
                ["name": user.name, "userPhoto": user.imageURL],
                withCompletionBlock: { (error:Error?, ref: DatabaseReference) in
                    onComplete?(error)
                }
            )
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
                "topic": group.topic,
                "long": group.long,
                "lat": group.lat
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
