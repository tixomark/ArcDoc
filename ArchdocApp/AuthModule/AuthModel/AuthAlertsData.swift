//
//  AuthAlertsData.swift
//  ArchdocApp
//
//  Created by tixomark on 2/22/23.
//

import Foundation

enum AuthAlertData {
    case noUser
    case wrongPassword
    case emailIsOccupied
    
    init(_ error: AuthError) {
        switch error {
        case .noUserWithThisEmail:
            self = .noUser
        case .passwordIsInvalid:
            self = .wrongPassword
        case .emailIsAlreadyInUse:
            self = .emailIsOccupied
        }
    }

    func dataForAlert() -> (String, String) {
        var title = ""
        var message = ""
        switch self {
        case .noUser:
            title = "No User"
            message = "There is no user record corresponding to this email."
        case .wrongPassword:
            title = "Wrong Password"
            message = "The password is invalid or the user does not have a password."
        case .emailIsOccupied:
            title = "Email Unavalable"
            message = "The email address is already in use by another account."
        }
        return (title, message)
    }
}
