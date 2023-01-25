//
//  TabBarItem.swift
//  ArchdocApp
//
//  Created by tixomark on 1/24/23.
//

import Foundation

struct TabBarItem {
    
    var name: String
    var normalStateImageName: String
    var selectedStateImageName: String
    
    static let items: [TabBarItem] = [
        TabBarItem(name: "Catalogue", normalStateImageName: "list", selectedStateImageName: ""),
        TabBarItem(name: "About Us", normalStateImageName: "info", selectedStateImageName: "")]
}
