//
//  ServiceProtocol.swift
//  ArchdocApp
//
//  Created by tixomark on 2/22/23.
//

import Foundation

enum Service {
    case dataProvider, router, authService, firestore, moduleBuilder
}

protocol ServiceProtocol: CustomStringConvertible {
    
}

protocol ServiceObtainableProtocol {
    var neededServices: [Service] {get}
    func getServices(_ services: [Service: ServiceProtocol])
}
