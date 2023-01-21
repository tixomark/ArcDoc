//
//  AssemblyModuleBuilder.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule() -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createMainModule() -> UIViewController {
        let view = MainViewController()
        let dataProvider = DataProvider()
        let presenter = MainPresenter(view: view, dataProvider: dataProvider)
        view.presenter = presenter
        return view
    }
    
    
}
