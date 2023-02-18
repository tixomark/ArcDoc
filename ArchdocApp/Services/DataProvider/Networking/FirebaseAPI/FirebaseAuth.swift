//
//  AuthService.swift
//  ArchdocApp
//
//  Created by tixomark on 2/13/23.
//

import Foundation
import Firebase
import FirebaseAuth

protocol FirebaseAuthProtocol {
    var isUserLoggedIn: Bool {get}
    func createUser(withEmail email: String, password: String, _ completion: ((Error?) -> ())?)
    func signIn(withEmail email: String, password: String, _ completion: ((Error?) -> ())?)
    func signOut() -> Bool
    func sendEmailVerification(_ completion: ((Error?) -> ())?)
    func reloadUser(_ completion: ((Error?) -> ())?)
    func sendPasswordReset(withEmail email: String, _ completion: ((Error?) -> ())?)
}

class FirebaseAuth: FirebaseAuthProtocol {
    
    var isUserLoggedIn: Bool {
        let isLogged = Auth.auth().currentUser != nil
        return isLogged
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
