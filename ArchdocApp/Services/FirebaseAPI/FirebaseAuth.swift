//
//  AuthService.swift
//  ArchdocApp
//
//  Created by tixomark on 2/13/23.
//

import Foundation
import Firebase

protocol FirebaseAuthProtocol {
    var user: Firebase.User? {get}
    var isUserLoggedIn: Bool {get}
    var curentUserID: String? {get}
    var authState: UserAuthState {get}
    func createUser(withEmail email: String, password: String, _ completion: ((Error?) -> ())?)
    func signIn(withEmail email: String, password: String, _ completion: ((Error?) -> ())?)
    func signOut() -> Bool
    func sendEmailVerification(_ completion: ((Error?) -> ())?)
    func reloadUser(_ completion: ((Error?) -> ())?)
    func sendPasswordReset(withEmail email: String, _ completion: ((Error?) -> ())?)
    
    func addAuthListenerFor(listenerOwner owner: CustomStringConvertible, completion: @escaping (Firebase.User?) -> ())
    func removeAuthListener(of owner: CustomStringConvertible)
}

enum UserAuthState {
    case noUser, userSignedIn
}

class FirebaseAuth: FirebaseAuthProtocol, ServiceProtocol {
    var description: String {
        return "FirebaseAuth"
    }
    
    var user: Firebase.User? {
        Auth.auth().currentUser
    }
    var isUserLoggedIn: Bool {
        let isLogged = user != nil
        return isLogged
    }
    var curentUserID: String? {
        guard let user = user else {
            print("'FirebaseAuth' no user is authenticated")
            return nil
        }
        return user.uid
    }
    
    var authState: UserAuthState {
        return user != nil ? .userSignedIn : .noUser
    }
    
    private var authListeners: [String:AuthStateDidChangeListenerHandle] = [:]
    
    func addAuthListenerFor(listenerOwner owner: CustomStringConvertible, completion: @escaping (Firebase.User?) -> ()) {
        let listener = Auth.auth().addStateDidChangeListener { _, user in
            if user != nil {
                Auth.auth().currentUser?.reload(completion: { error in
                    guard error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    completion(user)
                })
            } else {
                completion(user)
                print("'FirebaseAuth' got nil after reloading current user")
            }
        }
        print("'FirebaseAuth' added auth user state listener for \(owner.description)")
        authListeners[owner.description] = listener
    }
    
    func removeAuthListener(of owner: CustomStringConvertible) {
        guard let listenerToRemove = authListeners.removeValue(forKey: owner.description) else { return }
        Auth.auth().removeStateDidChangeListener(listenerToRemove)
        print("'FirebaseAuth' removed auth user dir listener for \(owner.description)")
    }
    
    func createUser(withEmail email: String, password: String, _ completion: ((Error?) -> ())? = nil) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error {
                completion?(err)
            }
            completion?(nil)
        }
    }
    
    func signIn(withEmail email: String, password: String, _ completion: ((Error?) -> ())? = nil) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let err = error{
                completion?(err)
                return
            }
            completion?(nil)
        }
    }
    
    func signOut() -> Bool {
        do{
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    func sendEmailVerification(_ completion: ((Error?) -> ())? = nil){
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            completion?(error)
        })
    }
    
    func reloadUser(_ completion: ((Error?) -> ())? = nil){
        Auth.auth().currentUser?.reload(completion: { (error) in
            completion?(error)
        })
    }
    
    func sendPasswordReset(withEmail email: String, _ completion: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion?(error)
        }
    }
    
    
}
