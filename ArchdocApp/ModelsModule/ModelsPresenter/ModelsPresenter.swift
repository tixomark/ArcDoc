//
//  MainPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation

protocol ModelsControllerProtocol {
    var presenter: ModelsPresenterProtocol! {get}
}

protocol ModelsViewProtocol: AnyObject {
    var presenter: ModelsPresenterProtocol! {get}
    func reloadTable()
}

protocol ModelsPresenterProtocol {
    init(view: ModelsViewProtocol, dataProvider: DataProviderProtocol, router: RouterProtocol)
    var architecture: [Architecture]? {get set}
    var dataProvider: DataProviderProtocol! {get}
    func getArchitecture()
    func tappedOnCell(atIndexPath indexPath: IndexPath)
    
}

class ModelsPresenter: ModelsPresenterProtocol {
    
    weak var view: ModelsViewProtocol!
    var dataProvider: DataProviderProtocol!
    var router: RouterProtocol!
    var architecture: [Architecture]?
    
    required init(view: ModelsViewProtocol, dataProvider: DataProviderProtocol, router: RouterProtocol) {
        self.view = view
        self.dataProvider = dataProvider
        self.router = router
        getArchitecture()
        
    }
    
    deinit {
        print("deinit 'ModelsPresenter'")
    }
    
    func getArchitecture() {
        dataProvider.getArchitecture(completion: { architecture in
            self.architecture = architecture
            print("models table will reload data \(Thread.current)")
            DispatchQueue.main.async { 
                self.view.reloadTable()
            }
        })
    }
    
    func tappedOnCell(atIndexPath indexPath: IndexPath) {
        guard let arch = architecture?[indexPath.row] else { return }
        router.showModelDetailModule(architectureItem: arch, dataProvider: dataProvider)
    }
    

}


