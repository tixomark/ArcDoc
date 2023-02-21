//
//  AssemblyModuleBuilder.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    
    func createScreenSelectorModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> ScreenSelectorView
    
    // MARK: - ModelsModule related logic
    func createModelsModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> ModelsNavigationController
    func createModelDetailModule(architecture item: Architecture?, router: RouterProtocol, dataProvider: DataProviderProtocol) -> DetailViewController
    func createModelTriDSceneModule(router: RouterProtocol, modelUrl: URL) -> TriDSceneViewController
    // MARK: -  related logic
    // MARK: -  related logic
    
    // MARK: - SettingsModule related logic
    func createSettingsModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> SettingsNavigationController
    func createEditUserModule(router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol) -> EditUserViewController
    func createAboutUsModule(router: RouterProtocol) -> AboutUsViewController
    func createAuthenticationModule(router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol) -> AuthViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    // MARK: - ScreenSelector logic
    
    func createScreenSelectorModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> ScreenSelectorView {
        let view = ScreenSelectorView()
        let presenter = ScreenSelectorPresenter(view: view, dataProvider: dataProvider, router: router)
        view.presenter = presenter
        return view
    }
    
    // MARK: - ModelsModule related logic
    
    func createModelsModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> ModelsNavigationController {
        let view = ModelsViewController()
        let navigation = ModelsNavigationController(rootViewController: view)
        let presenter = ModelsPresenter(view: view, dataProvider: dataProvider, router: router)
        view.presenter = presenter
        navigation.presenter = presenter
        return navigation
    }

    func createModelDetailModule(architecture item: Architecture?, router: RouterProtocol, dataProvider: DataProviderProtocol) -> DetailViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, architectureItem: item, router: router, dataProvider: dataProvider)
        view.presenter = presenter
        return view
    }

    func createModelTriDSceneModule(router: RouterProtocol, modelUrl: URL) -> TriDSceneViewController {
        let view = TriDSceneViewController()
        let triDSceneView = TriDSceneView()
        view.sceneView = triDSceneView
        let presenter = TriDScenePresenter(view: view, router: router, modelUrl: modelUrl, triDScene: triDSceneView)
        view.presenter = presenter
        return view
    }
    
    // MARK: -  related logic
    // MARK: -  related logic
    
    // MARK: - SettingsModule related logic
    
    func createSettingsModule(router: RouterProtocol, dataProvider: DataProviderProtocol) -> SettingsNavigationController {
        let view = SettingsViewController()
        let authService = FirebaseAuth()
        let firestore = FirestoreDB()
        let navigation = SettingsNavigationController(rootViewController: view)
        let presenter = SettingsPresenter(view: view, router: router, dataProvider: dataProvider, authService: authService, firestore: firestore)
        view.presenter = presenter
        navigation.presenter = presenter
        return navigation
    }
    
    func createEditUserModule(router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol) -> EditUserViewController {
        let view = EditUserViewController()
        let presenter = EditUserPresenter(view: view, router: router, dataProvider: dataProvider, authService: authService, firestore: firestore)
        view.presenter = presenter
        return view
    }
    
    func createAboutUsModule(router: RouterProtocol) -> AboutUsViewController {
        let view = AboutUsViewController()
        let presenter = AboutUsPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createAuthenticationModule(router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol) -> AuthViewController {
        let view = AuthViewController()
        let presenter = AuthPresenter(view: view, router: router, dataProvider: dataProvider, authService: authService, firestore: firestore)
        view.presenter = presenter
        return view
    }
    

}
