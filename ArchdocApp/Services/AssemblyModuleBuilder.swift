//
//  AssemblyModuleBuilder.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol: AnyObject {
    func getRouter() -> Router
    func createScreenSelectorModule() -> ScreenSelectorView
    
    // MARK: - Models section related logic
    func createModelsModule() -> ModelsNavigationController 
    func createModelDetailModule(architecture item: Architecture?) -> DetailViewController
    func createModelTriDSceneModule(modelUrl: URL) -> TriDSceneViewController
    
    // MARK: -  Card section related logic
    
    // MARK: -  Literature section related logic
    func createLiteratureModule() -> LiteratureNavigationController
    
    // MARK: - Settings section related logic
    func createSettingsModule() -> SettingsNavigationController
    
    func createAuthenticationModule() -> AuthNavigationController
    func createEmailVerificationModule() -> EmailVerificationViewController
    func createEnterUserDetailsModule() -> EnterUserDetailsViewController
    
    func createEditUserModule() -> EditUserViewController
    func createAboutUsModule() -> AboutUsViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol, ServiceProtocol {
    var description: String {
        return "AssemblyModuleBuilder"
    }
    
    var services: [Service:ServiceProtocol] = [:]
    
    init() {
        services[.dataProvider] = DataProvider()
        services[.authService] = FirebaseAuth()
        services[.firestore] = FirestoreDB()
        services[.moduleBuilder] = self
        
        let router = Router()
        injectServices(forObject: router)
        services[.router] = router
    }
    
    private func injectServices(forObject object: ServiceObtainableProtocol) {
        let neededServices = object.neededServices
        var servicesDict: [Service:ServiceProtocol] = [:]
        neededServices.forEach { service in
            servicesDict[service] = self.services[service]
        }
        object.getServices(servicesDict)
    }
    
    func getRouter() -> Router {
        return services[.router] as! Router
    }

    // MARK: - ScreenSelector logic
    
    func createScreenSelectorModule() -> ScreenSelectorView {
        let view = ScreenSelectorView()
        let presenter = ScreenSelectorPresenter(view: view)
        injectServices(forObject: presenter)
        view.presenter = presenter
        return view
    }

    // MARK: - Models section related logic
    
    func createModelsModule() -> ModelsNavigationController {
        let view = ModelsViewController()
        let presenter = ModelsPresenter(view: view)
        injectServices(forObject: presenter)
        view.presenter = presenter
        
        let navigation = ModelsNavigationController(rootViewController: view)
        navigation.presenter = presenter
        return navigation
    }
    
    func createModelDetailModule(architecture item: Architecture?) -> DetailViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, architectureItem: item)
        injectServices(forObject: presenter)
        view.presenter = presenter
        return view
    }

    func createModelTriDSceneModule(modelUrl: URL) -> TriDSceneViewController {
        let view = TriDSceneViewController()
        let triDSceneView = TriDSceneView()
        view.sceneView = triDSceneView
        let presenter = TriDScenePresenter(view: view, modelUrl: modelUrl, triDScene: triDSceneView)
        injectServices(forObject: presenter)
        view.presenter = presenter
        return view
    }
    
    // MARK: -  Card section related logic
    
    // MARK: -  Literature section related logic
    
    func createLiteratureModule() -> LiteratureNavigationController {
        let view = LiteratureViewController()
        let presenter = LiteraturePresenter(view: view)
        injectServices(forObject: presenter)
        view.presenter = presenter
        let navigation = LiteratureNavigationController(rootViewController: view)
        navigation.presenter = presenter
        return navigation
    }
    
    // MARK: - Settings section related logic
    
    func createSettingsModule() -> SettingsNavigationController {
        let view = SettingsViewController()
        let presenter = SettingsPresenter(view: view)
        injectServices(forObject: presenter)
        view.presenter = presenter
        let navigation = SettingsNavigationController(rootViewController: view)
        navigation.presenter = presenter
        return navigation
    }
    
    func createAuthenticationModule() -> AuthNavigationController {
        let view = AuthViewController()
        let presenter = AuthPresenter(view: view)
        injectServices(forObject: presenter)
        view.presenter = presenter
        let navigation = AuthNavigationController(rootViewController: view)
        navigation.presenter = presenter
        return navigation
    }
    
    func createEmailVerificationModule() -> EmailVerificationViewController {
        let view = EmailVerificationViewController()
        let presenter = EmailVerificationPresenter(view: view)
        injectServices(forObject: presenter)
        view.presenter = presenter
        return view
    }
    
    func createEnterUserDetailsModule() -> EnterUserDetailsViewController {
        let view = EnterUserDetailsViewController()
        let presenter = EnterUserDetailsPresenter(view: view)
        injectServices(forObject: presenter)
        view.presenter = presenter
        return view
    }
    
    func createEditUserModule() -> EditUserViewController {
        let view = EditUserViewController()
        let presenter = EditUserPresenter(view: view)
        injectServices(forObject: presenter)
        view.presenter = presenter
        return view
    }
    
    func createAboutUsModule() -> AboutUsViewController {
        let view = AboutUsViewController()
        let presenter = AboutUsPresenter(view: view)
        injectServices(forObject: presenter)
        view.presenter = presenter
        return view
    }
    

}
