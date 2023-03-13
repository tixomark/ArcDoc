//
//  LiteraturePresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 3/4/23.
//

import Foundation

protocol LiteratureControllerProtocol {
    var presenter: LiteraturePresenterProtocol! {get}
}

protocol LiteratureViewProtocol: AnyObject {
    var presenter: LiteraturePresenterProtocol! {get}
    func reloadTable()
}

protocol LiteraturePresenterProtocol {
    init(view: LiteratureViewProtocol)
    var architecture: [Architecture]? {get set}
    func getArchitecture()
    func tappedOnCell(atIndexPath indexPath: IndexPath)
    
}

extension LiteraturePresenter: ServiceObtainableProtocol {
    var neededServices: [Service] {
        return [.router, .dataProvider, .firestore]
    }
    
    func getServices(_ services: [Service : ServiceProtocol]) {
        self.dataProvider = (services[.dataProvider] as! DataProviderProtocol)
        self.router = (services[.router] as! RouterProtocol)
        self.firestore = (services[.firestore] as! FirestoreDBProtocol)
    }
}

class LiteraturePresenter: LiteraturePresenterProtocol {
    var dataProvider: DataProviderProtocol!
    var router: RouterProtocol!
    var firestore: FirestoreDBProtocol!
    
    weak var view: LiteratureViewProtocol!
    var architecture: [Architecture]?
    
    required init(view: LiteratureViewProtocol) {
        self.view = view
    }
    
    deinit {
        print("deinit 'LiteraturePresenter'")
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
