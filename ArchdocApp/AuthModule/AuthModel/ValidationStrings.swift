//
//  AuthErrors.swift
//  ArchdocApp
//
//  Created by tixomark on 2/17/23.
//

import Foundation

enum Validation: String {
    case none = ""
    case emailFailure = "Enter valid email address."
    case passwordHint = "Password must contain at least 8 simbols."
    case passwordsDontMatch = "Passwords don't match."
}


