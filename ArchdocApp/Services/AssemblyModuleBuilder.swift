//
//  AssemblyModuleBuilder.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> UIViewController
    func createDetailModule(architecture item: Architecture?, router: RouterProtocol, dataProvider: DataProviderProtocol) -> UIViewController
    func createTriDSceneModule(router: RouterProtocol, modelUrl: URL) -> TriDSceneViewController
    
    func createAboutUsModule(router: RouterProtocol) -> AboutUsViewController
    func createScreenSelectorModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> ScreenSelectorView
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view, dataProvider: dataProvider, router: router)
        view.presenter = presenter
        
        return view
    }
    
    func createDetailModule(architecture item: Architecture?, router: RouterProtocol, dataProvider: DataProviderProtocol) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, architectureItem: item,
                                        router: router, dataProvider: dataProvider)
        view.presenter = presenter
        
        return view
    }
    
    func createAboutUsModule(router: RouterProtocol) -> AboutUsViewController {
        let view = AboutUsViewController()
        let presenter = AboutUsPresenter(view: view, router: router)
        view.presenter = presenter
        
        return view
    }

    func createScreenSelectorModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> ScreenSelectorView {
        let view = ScreenSelectorView()
        let presenter = ScreenSelectorPresenter(view: view, dataProvider: dataProvider, router: router)
        view.presenter = presenter
        
        return view
    }
    
    func createTriDSceneModule(router: RouterProtocol, modelUrl: URL) -> TriDSceneViewController {
        let view = TriDSceneViewController()
        let triDSceneView = TriDSceneView()
        view.sceneView = triDSceneView
        let presenter = TriDScenePresenter(view: view, router: router, modelUrl: modelUrl, triDScene: triDSceneView)
        view.presenter = presenter
        
        return view
    }
}
