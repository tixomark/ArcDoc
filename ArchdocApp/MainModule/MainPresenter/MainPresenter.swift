//
//  MainPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    var presenter: MainPresenterProtocol! {get}
    func reloadTable()
}

protocol MainPresenterProtocol {
    init(view: MainViewProtocol, dataProvider: DataProviderProtocol, router: RouterProtocol)
    var architecture: [Architecture]? {get set}
    var dataProvider: DataProviderProtocol! {get}
    func getArchitecture()
    func tapOnCell(architecture: Architecture?)
    
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewProtocol!
    var dataProvider: DataProviderProtocol!
    var router: RouterProtocol!
    var architecture: [Architecture]?
    
    required init(view: MainViewProtocol, dataProvider: DataProviderProtocol, router: RouterProtocol) {
        self.view = view
        self.dataProvider = dataProvider
        self.router = router
        getArchitecture()
        
    }
    
    func getArchitecture() {
        dataProvider.getArchitecture(completion: { architecture in
            self.architecture = architecture
            DispatchQueue.main.async { 
                self.view.reloadTable()
            }
        })
    }
    
    func tapOnCell(architecture: Architecture?) {
        router.showDetailModule(architectureItem: architecture, dataProvider: dataProvider)
    }
}


