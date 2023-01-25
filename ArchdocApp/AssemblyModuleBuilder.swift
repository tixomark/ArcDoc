//
//  AssemblyModuleBuilder.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(architecture item: Architecture?, router: RouterProtocol) -> UIViewController
    func createAboutUsModule(router: RouterProtocol) -> AboutUsViewController
    func createScreenSelectorModule(router: RouterProtocol) -> ScreenSelectorView
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let dataProvider = DataProvider()
        let presenter = MainPresenter(view: view, dataProvider: dataProvider, router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(architecture item: Architecture?, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, architectureItem: item, router: router)
        view.presenter = presenter
        return view
    }
    
    func createAboutUsModule(router: RouterProtocol) -> AboutUsViewController {
        let view = AboutUsViewController()
        let presenter = AboutUsPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }

    func createScreenSelectorModule(router: RouterProtocol) -> ScreenSelectorView {
        let view = ScreenSelectorView()
        let dataProvider = DataProvider()
        let presenter = ScreenSelectorPresenter(view: view, dataProvider: dataProvider, router: router)
        view.presenter = presenter
        
        return view
    }
    
    
}
