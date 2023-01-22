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
    var assemblyModuleBuilder: AssemblyBuilderProtocol? {get}
    
    func initialViewController()
    func showMainModule()
    func showDetailModule(architectureItem: Architecture?)
    
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    
    var assemblyModuleBuilder: AssemblyBuilderProtocol?
    
    init(navigationController: UINavigationController!, assemblyModuleBuilder: AssemblyBuilderProtocol!) {
        self.navigationController = navigationController
        self.assemblyModuleBuilder = assemblyModuleBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController,
           let mainVC = assemblyModuleBuilder?.createMainModule(router: self) {
            navigationController.viewControllers = [mainVC]
        }
    }
    
    func showMainModule() {
        
    }
    
    func showDetailModule(architectureItem: Architecture?) {
        if let navigationController = navigationController,
           let detailVC = assemblyModuleBuilder?.createDetailModule(architecture: architectureItem, router: self) {
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
    
    
}
