//
//  MainPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    
}

protocol MainViewPresenterProtocol {
    init(view: MainViewProtocol, dataProvider: DataProviderProtocol)
    var architecture: [Architecture]? {get set}
    func getArchitecture()
    func tapOnCell(architecture: Architecture)
    
}

class MainPresenter: MainViewPresenterProtocol {
    
    required init(view: MainViewProtocol, dataProvider: DataProviderProtocol) {
        self.view = view
        self.dataProvider = dataProvider
        getArchitecture()
        
    }
    
    weak var view: MainViewProtocol?
    var dataProvider: DataProviderProtocol!
    var architecture: [Architecture]?
    
    func getArchitecture() {
        
        architecture = dataProvider?.getArhitecture()
    }
    
    func tapOnCell(architecture: Architecture) {
        
    }
    
    
}


