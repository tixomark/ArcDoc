//
//  3DScenePresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/26/23.
//

import Foundation
import SceneKit

protocol TriDSceneViewProtocol: AnyObject {
    var presenter: TriDScenePresenterProtocol! {get}
    var sceneView: TriDSceneView! {get}
}

protocol TriDSceneProtocol: AnyObject {
    func returnToInitialState()
    func zoom(_ isZooming: Bool)
}

protocol TriDScenePresenterProtocol {
    var router: RouterProtocol? {get}
    var modelUrl: URL {get}
    
    init(view: TriDSceneViewProtocol, modelUrl: URL, triDScene: TriDSceneProtocol)
    func initialStateButtonTaped()
    func zoomButtonTapped(isZooming: Bool)
}

extension TriDScenePresenter: ServiceObtainableProtocol {
    var neededServices: [Service] {
        return [.router]
    }
    
    func getServices(_ services: [Service : ServiceProtocol]) {
        self.router = (services[.router] as! RouterProtocol)
    }
}

class TriDScenePresenter: TriDScenePresenterProtocol {
    var router: RouterProtocol?

    weak var view: TriDSceneViewProtocol?
    weak var sceneView: TriDSceneProtocol?
    var modelUrl: URL
    
    required init(view: TriDSceneViewProtocol, modelUrl: URL, triDScene: TriDSceneProtocol) {
        self.view = view
        self.modelUrl = modelUrl
        self.sceneView = triDScene
    }
    
    func initialStateButtonTaped() {
        sceneView?.returnToInitialState()
        print("init state")
    }
    
    func zoomButtonTapped(isZooming: Bool) {
        sceneView?.zoom(isZooming)
        print("zoom \(isZooming)")
    }
    
    deinit {
        print("deinit 'TriDScenePresenter'")
    }
    
    
    
}
