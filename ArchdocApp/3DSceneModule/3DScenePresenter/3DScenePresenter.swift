//
//  3DScenePresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/26/23.
//

import Foundation

protocol TriDSceneViewProtocol: AnyObject {
    var presenter: TriDScenePresenterProtocol? {get}
    
}

protocol TriDScenePresenterProtocol {
    init(view: TriDSceneViewProtocol, router: RouterProtocol)
    var router: RouterProtocol? {get}
    
    func swipeDown()
}

class TriDScenePresenter: TriDScenePresenterProtocol {
    weak var view: TriDSceneViewProtocol?
    let router: RouterProtocol?
    
    required init(view: TriDSceneViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        
    }
    
    func swipeDown() {
        router?.navigationController?.dismiss(animated: true)
    }
    
    
    
    
}
