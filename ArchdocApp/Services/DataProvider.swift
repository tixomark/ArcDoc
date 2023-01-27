//
//  DataProvider.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation

protocol DataProviderProtocol {
    func getArhitecture() -> [Architecture]
    func getTabBatItems() -> [TabBarItem] 
}

class DataProvider: DataProviderProtocol {
    func getArhitecture() -> [Architecture] {
        return Architecture.architecture
    }
    
    func getTabBatItems() -> [TabBarItem] {
        return TabBarItem.items
    }
}
