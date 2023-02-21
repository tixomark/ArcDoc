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
    
    init(assemblyModuleBuilder: AssemblyBuilderProtocol, window: UIWindow?)
    
    // MARK: - ModelsModule related logic
    func showModelsModule(dataProvider: DataProviderProtocol)
    func showModelDetailModule(architectureItem: Architecture?, dataProvider: DataProviderProtocol)
    func showModelTriDSceneModule(modelUrl: URL)
    // MARK: - SettingsModule related logic
    // MARK: - SettingsModule related logic
    
    // MARK: - SettingsModule related logic
    func showSettingsModule(dataProvider: DataProviderProtocol)
    func showEditUserModule(dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol)
    func showAboutUsModule()
    func showAuthenticationModule(dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol) 
    
}

private protocol RootControllersProtocol {
    associatedtype RootControllersKeys: Hashable
    var rootControllers: [RootControllersKeys : UIViewController] { get set }
}

class Router: RouterProtocol, RootControllersProtocol {
    fileprivate enum RootControllersKeys {
        case models, cards, literature, settings
    }
    fileprivate var rootControllers: [RootControllersKeys : UIViewController] = [:]
    
    var assemblyModuleBuilder: AssemblyBuilderProtocol?
    weak var window: UIWindow?

    required init(assemblyModuleBuilder: AssemblyBuilderProtocol, window: UIWindow?) {
        self.assemblyModuleBuilder = assemblyModuleBuilder
        self.window = window
        print("initialized Router")
    }
    
    // MARK: - ModelsModule related logic
    
    func showModelsModule(dataProvider: DataProviderProtocol) {
        if let modelsNC = rootControllers[.models] as? ModelsNavigationController {
            window?.rootViewController = modelsNC
            showScreenSelector()
            print("showing ModelsModule")
        } else if let modelsNC = assemblyModuleBuilder?.createModelsModule(router: self, dataProvider: dataProvider) {
            rootControllers[.models] = modelsNC
            print("created ModelsModule")
            showModelsModule(dataProvider: dataProvider)
        } else { print("Error while creating ModelsModule") }
    }
    
    func showModelDetailModule(architectureItem: Architecture?, dataProvider: DataProviderProtocol) {
        if let modelsNC = rootControllers[.models] as? ModelsNavigationController,
           let detailVC = assemblyModuleBuilder?.createModelDetailModule(architecture: architectureItem, router: self, dataProvider: dataProvider) {
            modelsNC.pushViewController(detailVC, animated: true)
            print("showing ModelDetailModule")
        } else { print("Error while showing ModelDetailModule") }
    }
    
    func showModelTriDSceneModule(modelUrl: URL) {
        if let modelsNC = rootControllers[.models] as? ModelsNavigationController,
           let triDSceneVC = assemblyModuleBuilder?.createModelTriDSceneModule(router: self, modelUrl: modelUrl) {
            modelsNC.pushViewController(triDSceneVC, animated: true)
            print("showing ModelTriDSceneModule")
        } else { print("Error while showing ModelTriDSceneModule") }
    }
    
    // MARK: - SettingsModule related logic
    // MARK: - SettingsModule related logic
    
    // MARK: - SettingsModule related logic
    
    func showSettingsModule(dataProvider: DataProviderProtocol) {
        if let settingsNC = rootControllers[.settings] {
            window?.rootViewController = settingsNC
            showScreenSelector()
            print("showing SettingsModule")
        } else if let settingsNC = assemblyModuleBuilder?.createSettingsModule(router: self, dataProvider: dataProvider) {
            rootControllers[.settings] = settingsNC
            print("created SettingsModule")
            showSettingsModule(dataProvider: dataProvider)
        } else { print("Error while creating SettingsModule") }
    }
    
    func showAuthenticationModule(dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol) {
        if let settingsNC = rootControllers[.settings] as? SettingsNavigationController,
           let authVC = assemblyModuleBuilder?.createAuthenticationModule(router: self, dataProvider: dataProvider, authService: authService, firestore: firestore) {
            settingsNC.pushViewController(authVC, animated: true)
            print("showing AuthenticationModule")
        } else { print("Error while showing AuthenticationModule") }
    }
    
    func showAboutUsModule() {
        if let settingsNC = rootControllers[.settings] as? SettingsNavigationController,
           let aboutUsVC = assemblyModuleBuilder?.createAboutUsModule(router: self){
            settingsNC.pushViewController(aboutUsVC, animated: true)
            print("showing AboutUsModule")
        } else { print("Error while showing AboutUsModule") }
    }
    
    func showEditUserModule(dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol) {
        if let settingsNC = rootControllers[.settings] as? SettingsNavigationController,
           let editUserVC = assemblyModuleBuilder?.createEditUserModule(router: self, dataProvider: dataProvider, authService: authService, firestore: firestore) {
            settingsNC.pushViewController(editUserVC, animated: true)
            print("showing EditUserModule")
        } else { print("Error while showing EditUserModule") }
    }
    
    private func showScreenSelector() {
        if let screenSelector = window?.subviews.first(where: { $0 is ScreenSelectorView }) {
            window?.bringSubviewToFront(screenSelector)
        }
    }
    
}
