//
//  FirebaseUser.swift
//  ArchdocApp
//
//  Created by tixomark on 2/19/23.
//

import Foundation

enum UserFields: String {
    case firstName, lastName, bio, username, email, phoneNumber, profileImage
}

struct User {
    var firstName: String
    var lastName: String
    var bio: String
    var username: String
    var email: String
    var phoneNumber: String
    var profileImage: String
    
    init(_ userData: [String:String] = [:]) {
        firstName = userData["firstName"] ?? ""
        lastName = userData["lastName"] ?? ""
        bio = userData["bio"] ?? ""
        username = userData["username"] ?? ""
        email = userData["email"] ?? ""
        phoneNumber = userData["phoneNumber"] ?? ""
        profileImage = userData["profileImage"] ?? ""
    }
    
    func makeDict(usingFields fields: [UserFields] = [.firstName, .lastName, .bio, .username, .email, .phoneNumber, .profileImage]) -> [String:String] {
        var dict: [String:String] = [:]
        for field in fields {
            switch field {
            case .firstName:
                dict["firstName"] = firstName
            case .lastName:
                dict["lastName"] = lastName
            case .bio:
                dict["bio"] = bio
            case .username:
                dict["username"] = username
            case .email:
                dict["email"] = email
            case .phoneNumber:
                dict["phoneNumber"] = phoneNumber
            case .profileImage:
                dict["profileImage"] = profileImage
            }
        }
        return dict
    }
    
}
