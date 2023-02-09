//
//  3DScenePresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/26/23.
//

import Foundation

protocol TriDSceneViewProtocol: AnyObject {
    var presenter: TriDScenePresenterProtocol! {get}
    
}

protocol TriDScenePresenterProtocol {
    var router: RouterProtocol? {get}
    var modelUrl: URL {get}
    
    init(view: TriDSceneViewProtocol, router: RouterProtocol, modelUrl: URL)
    func swipeDown()
}

class TriDScenePresenter: TriDScenePresenterProtocol {
    weak var view: TriDSceneViewProtocol?
    let router: RouterProtocol?
    var modelUrl: URL
    
    required init(view: TriDSceneViewProtocol, router: RouterProtocol, modelUrl: URL) {
        self.view = view
        self.router = router
        self.modelUrl = modelUrl
        
    }
    
    func swipeDown() {
        router?.navigationController?.dismiss(animated: true)
    }
    
    deinit {
        print("deinit TriDScenePresenter")
    }
    
    
    
}
