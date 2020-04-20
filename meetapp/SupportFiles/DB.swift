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

        func update(_ user: User) {
            update(user, onComplete: nil)
        }
        
        func update(_ user: User, onComplete: ((Error?) -> Void)?) {
            collection.child(user.uid).setValue(
                ["name": user.name, "userPhoto": user.imageURL],
                withCompletionBlock: { (error:Error?, ref: DatabaseReference) in
                    onComplete?(error)
                }
            )
        }
        
        func getUsersOfGroup(_ group:Group, onComplete: @escaping ([User]) -> Void) {
            let dispatchGroup = DispatchGroup()
            var users:[User] = []
            
            for uid in group.members {
                dispatchGroup.enter()
                get(uid, onSuccess: { (user:User) in
                    users.append(user)
                    dispatchGroup.leave()
                }, onError: { (error) in
                    dispatchGroup.leave()
                })
            }
            
            dispatchGroup.notify(queue: .main) {
                onComplete(users)
            }
        }
    }
    
    class Groups: Collection {
        init(_ ref: DatabaseReference) {
            super.init(ref, name:"groups")
        }
        
        func upsert(_ group: Group) {
            upsert(group, onComplete: nil)
        }
        
        // group.members.append(member) // to add
        // group.members = group.members.filter{ $0 != member } // to remove
        func upsert(_ group: Group, onComplete: ((Error?) -> Void)?) {
            collection.child(group.guid).setValue([
                "guid": group.guid,
                "owner": group.owner,
                "name": group.name,
                "level": group.level,
                "city": group.city,
                "topic": group.topic,
                "long": group.long,
                "lat": group.lat,
                "members": group.members
            ], withCompletionBlock: { (error:Error?, ref: DatabaseReference) in
                onComplete?(error)
            })
        }
        
        func observeAll(onSuccess: @escaping ([Group]) -> Void) {
            collection.observe(.value) { (snapshot) in
                var groups:[Group] = []
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let groupDict = snap.value as! [String: Any]
                    let groupElement: Group = Group(
                        guid: groupDict["guid"] as! String, owner: groupDict["owner"] as! String,
                        name: groupDict["name"] as! String, level: groupDict["level"] as! String,
                        city: groupDict["city"] as! String, topic: groupDict["topic"] as! String,
                        long: groupDict["long"] as! String, lat: groupDict["lat"] as! String,
                        members: groupDict["members"] as? [String] ?? [])
                    groups.append(groupElement)
                }
                onSuccess(groups)
            }
        }
        
        func delete(guid: String, onComplete: ((Error?) -> Void)?) {
            collection.child(guid).removeValue(completionBlock: { (error:Error?, ref: DatabaseReference) in
                onComplete?(error)
            })
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
