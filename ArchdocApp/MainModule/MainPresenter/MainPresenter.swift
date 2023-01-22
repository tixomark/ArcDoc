//
//  MainPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    var presenter: MainPresenterProtocol! {get}
    func getDimensionsOfImage(name: String?) -> (Float, Float)
}

protocol MainPresenterProtocol {
    init(view: MainViewProtocol, dataProvider: DataProviderProtocol, router: RouterProtocol)
    var architecture: [Architecture]? {get set}
    func getArchitecture()
    func tapOnCell(architecture: Architecture?)
    func getArchitectureImageDimensions(index: Int) -> (Float, Float)
    
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
        
        architecture = dataProvider?.getArhitecture()
    }
    
    func tapOnCell(architecture: Architecture?) {
        router.showDetailModule(architectureItem: architecture)
    }
    
    func getArchitectureImageDimensions(index: Int) -> (Float, Float){
        let imageName = architecture?[index].imageName
        return view.getDimensionsOfImage(name: imageName)
    }
    
}


