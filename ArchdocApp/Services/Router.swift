//
//  Router.swift
//  ArchdocApp
//
//  Created by tixomark on 1/22/23.
//

import Foundation
import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController? {get}
    var aboutUsViewController: AboutUsViewController? {get}
    var assemblyModuleBuilder: AssemblyBuilderProtocol? {get}
    var window: UIWindow? {get}
    
    func initialViewController()
    func showMainModule()
    func showDetailModule(architectureItem: Architecture?)
    func showAboutUsModule()
    func showTriDSceneModule()
    
}

class Router: RouterProtocol {
    weak var window: UIWindow?
    var navigationController: UINavigationController?
    var aboutUsViewController: AboutUsViewController?
    var assemblyModuleBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController!, assemblyModuleBuilder: AssemblyBuilderProtocol!, window: UIWindow?) {
        self.navigationController = navigationController
        self.assemblyModuleBuilder = assemblyModuleBuilder
        self.window = window
    }
    
    func initialViewController() {
        if let navigationController = navigationController,
           let mainVC = assemblyModuleBuilder?.createMainModule(router: self) {
            navigationController.viewControllers = [mainVC]
        }
    }
    
    func showMainModule() {
        if let navigationController = navigationController,
           let screenSelecor = window?.subviews.first(where: { $0 is ScreenSelectorView }) {
            
            window?.rootViewController = navigationController
            window?.bringSubviewToFront(screenSelecor)
        }
    }
    
    func showDetailModule(architectureItem: Architecture?) {
        if let navigationController = navigationController,
           let detailVC = assemblyModuleBuilder?.createDetailModule(architecture: architectureItem, router: self) {
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
    
    func showAboutUsModule() {
        if aboutUsViewController == nil {
            aboutUsViewController = assemblyModuleBuilder?.createAboutUsModule(router: self)
        }

        guard window?.rootViewController != aboutUsViewController else {return}
        window?.rootViewController = aboutUsViewController
        
        guard let screenSelecor = window?.subviews.first(where: { $0 is ScreenSelectorView }) else {return}
        window?.bringSubviewToFront(screenSelecor)
    }
    
    func showTriDSceneModule() {
        if let navigationController = navigationController,
           let triDSceneVC = assemblyModuleBuilder?.createTriDSceneModule(router: self) {
            navigationController.pushViewController(triDSceneVC, animated: true)
        }
    }
}
