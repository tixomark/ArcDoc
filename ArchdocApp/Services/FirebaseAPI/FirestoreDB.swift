//
//  FirebaseDataStorage.swift
//  ArchdocApp
//
//  Created by tixomark on 2/13/23.
//

import Foundation
import Firebase

protocol FirestoreDBProtocol {
    func addUserSnapshotListenerFor(listenerOwner owner: CustomStringConvertible, userID id: String, completion: @escaping (User?) -> ())
    func removeUserSnapshotListener(of owner: CustomStringConvertible)
    
    func getUserDataFor(userID id: String, completion: @escaping (User?) -> ())
    func setUserData(using data: [String:String], forUserID id: String, completion: @escaping (Bool) -> ())
    func updateUserData(using data: [String:String], forUserID id: String, completion: @escaping (Bool) -> ())
}

class FirestoreDB: FirestoreDBProtocol, ServiceProtocol {
    var description: String {
        return "FirestoreDB"
    }

    private var db: Firestore {
        return Firestore.firestore()
    }
    
    private var usersDir: String {
        return "users"
    }
    
    private var userListeners: [String:ListenerRegistration] = [:]

    func addUserSnapshotListenerFor(listenerOwner owner: CustomStringConvertible, userID id: String, completion: @escaping (User?) -> ()) {
        var user: User?
        let listener = db.collection(usersDir).document(id).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(user)
            } else {
                if let data = snapshot?.data() as? [String:String] {
                    user = User(data)
                    completion(user)
                }
            }
        }
        print("'FirestoreDB' added user dir listener for \(owner.description)")
        userListeners[owner.description] = listener
    }
    
    func removeUserSnapshotListener(of owner: CustomStringConvertible) {
        userListeners[owner.description]?.remove()
        userListeners.removeValue(forKey: owner.description)
        print("'FirestoreDB' removed user dir listener for \(owner.description)")
    }
    
    func getUserDataFor(userID id: String, completion: @escaping (User?) -> ()) {
        db.collection(usersDir).document(id).getDocument { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            guard let data = snapshot?.data() as? [String:String] else {
                print("'FirestoreDB' problems with decoding \(String(describing: snapshot?.data()))")
                completion(nil)
                return
            }
            let user = User(data)
            completion(user)
        }
    }
    
    func setUserData(using data: [String:String], forUserID id: String, completion: @escaping (Bool) -> ()) {
        db.collection(usersDir).document(id).setData(data) { error in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func updateUserData(using data: [String:String], forUserID id: String, completion: @escaping (Bool) -> ()) {
        db.collection(usersDir).document(id).updateData(data) { error in
            guard error == nil else {
                print(error!.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func addListener(userID id: String, completion: @escaping (Bool, User?) -> ()) {
        var user: User?
        db.collection(usersDir).document(id).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false, user)
            } else {
                if let data = snapshot?.data() as? [String:String] {
                    user = User(data)
                    completion(true, user)
                }
            }
        }
    }
    
    func updateCurrentUserData(using userdata: User) {
        
    }
    
}

