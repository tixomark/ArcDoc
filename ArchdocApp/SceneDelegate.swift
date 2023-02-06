//
//  SceneDelegate.swift
//  ArchdocApp
//
//  Created by Василий Васильевич on 21.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var screenSelector: ScreenSelectorView?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        
        let navigationController = UINavigationController()
        let assemblyBuilder = AssemblyModuleBuilder()
        let router = Router(navigationController: navigationController, assemblyModuleBuilder: assemblyBuilder, window: window)
        let dataProvider = DataProvider()
        
        router.initialViewController(dataProvider: dataProvider)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        screenSelector = assemblyBuilder.createScreenSelectorModule(router: router, dataProvider: dataProvider)
        setScreenSelector()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    
}

extension SceneDelegate {
    func setScreenSelector() {
        guard let screenSelector = screenSelector, let window = window else {return}
        window.addSubview(screenSelector)
        
        screenSelector.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            screenSelector.heightAnchor.constraint(equalToConstant: 50),
            screenSelector.leadingAnchor.constraint(equalTo: window.leadingAnchor,
                                                    constant: window.bounds.width / 5),
            screenSelector.trailingAnchor.constraint(equalTo: window.trailingAnchor,
                                                     constant: -(window.bounds.width / 5)),
            screenSelector.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -20),
            screenSelector.centerXAnchor.constraint(equalTo: window.centerXAnchor)])
    }
}
