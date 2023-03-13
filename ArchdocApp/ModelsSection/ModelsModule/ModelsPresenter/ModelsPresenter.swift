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
    init(view: ModelsViewProtocol)
    var architecture: [Architecture]? {get set}
    func getArchitecture()
    func tappedOnCell(atIndexPath indexPath: IndexPath)
    
}

extension ModelsPresenter: ServiceObtainableProtocol {
    var neededServices: [Service] {
        return [.router, .dataProvider]
    }
    
    func getServices(_ services: [Service : ServiceProtocol]) {
        self.dataProvider = (services[.dataProvider] as! DataProviderProtocol)
        self.router = (services[.router] as! RouterProtocol)
    }
}

class ModelsPresenter: ModelsPresenterProtocol {
    var dataProvider: DataProviderProtocol!
    var router: RouterProtocol!
    
    weak var view: ModelsViewProtocol!
    var architecture: [Architecture]?
    
    required init(view: ModelsViewProtocol) {
        self.view = view
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
        router.showModelDetailModule(architectureItem: arch)
    }
    

}


