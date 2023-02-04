//
//  DetailPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/22/23.
//

import Foundation

protocol DetailViewProtocol: AnyObject {
    var presenter: DetailPresenterProtocol! {get}
    func setUIData(architectureItem: Architecture?)
}

protocol DetailPresenterProtocol {
    var architectureItem: Architecture? {get set}
    var router: RouterProtocol? {get}
    var dataProvider: DataProviderProtocol? {get}
    
    init(view: DetailViewProtocol, architectureItem: Architecture?, router: RouterProtocol, dataProvider: DataProviderProtocol)
    func setUIData()
    func didTapOn3DViewButton()
}

class DetailPresenter: DetailPresenterProtocol {
    weak var view: DetailViewProtocol!
    var architectureItem: Architecture?
    var router: RouterProtocol?
    var dataProvider: DataProviderProtocol?
    
    required init(view: DetailViewProtocol, architectureItem: Architecture?, router: RouterProtocol, dataProvider: DataProviderProtocol) {
        self.view = view
        self.architectureItem = architectureItem
        self.router = router
        self.dataProvider = dataProvider
        
    }
    
    func setUIData() {
        view.setUIData(architectureItem: architectureItem)
    }
    
    func didTapOn3DViewButton() {
        guard let arch = architectureItem else { return }
        
        dataProvider?.getUSDZModelOf(architectureUID: arch.uid, completion: { modelUrl in
            DispatchQueue.main.async {
                self.router?.showTriDSceneModule(modelUrl: modelUrl)
            }
        })
        
    }
    
    deinit {
        print("deinit presenter")
    }
    
}
