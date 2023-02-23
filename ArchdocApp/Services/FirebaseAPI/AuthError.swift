//
//  AuthErrors.swift
//  ArchdocApp
//
//  Created by tixomark on 2/18/23.
//

import Foundation

enum AuthError: String {
    case noUserWithThisEmail = "There is no user record corresponding to this identifier. The user may have been deleted."
    case passwordIsInvalid = "The password is invalid or the user does not have a password."
    case emailIsAlreadyInUse = "The email address is already in use by another account."
}
