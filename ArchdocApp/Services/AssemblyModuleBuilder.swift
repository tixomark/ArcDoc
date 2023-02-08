//
//  AssemblyModuleBuilder.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> MainViewController
    func createDetailModule(architecture item: Architecture?, router: RouterProtocol, dataProvider: DataProviderProtocol) -> DetailViewController
    func createTriDSceneModule(router: RouterProtocol, modelUrl: URL) -> TriDSceneViewController
    func createAboutUsModule(router: RouterProtocol) -> AboutUsViewController
    func createScreenSelectorModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> ScreenSelectorView
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    func createMainModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> MainViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view, dataProvider: dataProvider, router: router)
        view.presenter = presenter

        return view
    }

    func createDetailModule(architecture item: Architecture?, router: RouterProtocol, dataProvider: DataProviderProtocol) -> DetailViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, architectureItem: item, router: router, dataProvider: dataProvider)
        view.presenter = presenter

        return view
    }

    func createAboutUsModule(router: RouterProtocol) -> AboutUsViewController {
        let view = AboutUsViewController()
        let presenter = AboutUsPresenter(view: view as! AboutUsViewProtocol, router: router)
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
        let presenter = TriDScenePresenter(view: view, router: router, modelUrl: modelUrl)
        view.presenter = presenter

        return view
    }
}
