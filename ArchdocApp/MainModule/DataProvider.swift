//
//  DataProvider.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation

protocol DataProviderProtocol {
    func getArhitecture() -> [Architecture]
}

class DataProvider: DataProviderProtocol {
    func getArhitecture() -> [Architecture] {
        return Architecture.architecture
    }
    
}
