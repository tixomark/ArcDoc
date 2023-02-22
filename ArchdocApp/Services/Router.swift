//
//  Router.swift
//  ArchdocApp
//
//  Created by tixomark on 1/22/23.
//

import Foundation
import UIKit

protocol RouterProtocol {
    var window: UIWindow? {get}
     
    // MARK: - ModelsModule related logic
    func showModelsModule()
    func showModelDetailModule(architectureItem: Architecture?)
    func showModelTriDSceneModule(modelUrl: URL)
    // MARK: - SettingsModule related logic
    // MARK: - SettingsModule related logic
    
    // MARK: - SettingsModule related logic
    func showSettingsModule() 
    func showAuthenticationModule()
    func showEditUserModule()
    func showAboutUsModule()
}

private protocol RootControllersProtocol {
    associatedtype RootControllersKeys: Hashable
    var rootControllers: [RootControllersKeys : UIViewController] { get set }
}

extension Router: ServiceProtocol, ServiceObtainableProtocol {
    var description: String {
        return "Router"
    }
    
    var neededServices: [Service] {
        return  [.moduleBuilder]
    }
    
    func getServices(_ services: [Service : ServiceProtocol]) {
        self.assemblyModuleBuilder = (services[.moduleBuilder] as! AssemblyBuilderProtocol)
    }
}
class Router: RouterProtocol, RootControllersProtocol {
    
    fileprivate enum RootControllersKeys {
        case models, cards, literature, settings
    }
    fileprivate var rootControllers: [RootControllersKeys : UIViewController] = [:]
    
    var assemblyModuleBuilder: AssemblyBuilderProtocol?
    weak var window: UIWindow?
    
    // MARK: - ModelsModule related logic
    
    func showModelsModule() {
        if let modelsNC = rootControllers[.models] as? ModelsNavigationController {
            window?.rootViewController = modelsNC
            showScreenSelector()
            print("showing ModelsModule")
        } else if let modelsNC = assemblyModuleBuilder?.createModelsModule() {
            rootControllers[.models] = modelsNC
            print("created ModelsModule")
            showModelsModule()
        } else { print("Error while creating ModelsModule") }
    }
    
    func showModelDetailModule(architectureItem: Architecture?) {
        if let modelsNC = rootControllers[.models] as? ModelsNavigationController,
           let detailVC = assemblyModuleBuilder?.createModelDetailModule(architecture: architectureItem) {
            modelsNC.pushViewController(detailVC, animated: true)
            print("showing ModelDetailModule")
        } else { print("Error while showing ModelDetailModule") }
    }
    
    func showModelTriDSceneModule(modelUrl: URL) {
        if let modelsNC = rootControllers[.models] as? ModelsNavigationController,
           let triDSceneVC = assemblyModuleBuilder?.createModelTriDSceneModule(modelUrl: modelUrl) {
            modelsNC.pushViewController(triDSceneVC, animated: true)
            print("showing ModelTriDSceneModule")
        } else { print("Error while showing ModelTriDSceneModule") }
    }
    
    // MARK: - SettingsModule related logic
    // MARK: - SettingsModule related logic
    
    // MARK: - SettingsModule related logic
    
    func showSettingsModule() {
        if let settingsNC = rootControllers[.settings] {
            window?.rootViewController = settingsNC
            showScreenSelector()
            print("showing SettingsModule")
        } else if let settingsNC = assemblyModuleBuilder?.createSettingsModule() {
            rootControllers[.settings] = settingsNC
            print("created SettingsModule")
            showSettingsModule()
        } else { print("Error while creating SettingsModule") }
    }
    
    func showAuthenticationModule() {
        if let settingsNC = rootControllers[.settings] as? SettingsNavigationController,
           let authVC = assemblyModuleBuilder?.createAuthenticationModule() {
            settingsNC.pushViewController(authVC, animated: true)
            print("showing AuthenticationModule")
        } else { print("Error while showing AuthenticationModule") }
    }
    
    func showEditUserModule() {
        if let settingsNC = rootControllers[.settings] as? SettingsNavigationController,
           let editUserVC = assemblyModuleBuilder?.createEditUserModule() {
            settingsNC.pushViewController(editUserVC, animated: true)
            print("showing EditUserModule")
        } else { print("Error while showing EditUserModule") }
    }
    
    func showAboutUsModule() {
        if let settingsNC = rootControllers[.settings] as? SettingsNavigationController,
           let aboutUsVC = assemblyModuleBuilder?.createAboutUsModule(){
            settingsNC.pushViewController(aboutUsVC, animated: true)
            print("showing AboutUsModule")
        } else { print("Error while showing AboutUsModule") }
    }
    
    private func showScreenSelector() {
        if let screenSelector = window?.subviews.first(where: { $0 is ScreenSelectorView }) {
            window?.bringSubviewToFront(screenSelector)
        }
    }
    
}
