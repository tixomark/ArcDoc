//
//  MainPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    var presenter: MainPresenterProtocol! {get}
    func getDimensionsOfImage(url: URL) -> CGSize? 
    func reloadTable()
}

protocol MainPresenterProtocol {
    init(view: MainViewProtocol, dataProvider: DataProviderProtocol, router: RouterProtocol)
    var architecture: [Architecture]? {get set}
    var dataProvider: DataProviderProtocol! {get}
    func getArchitecture()
    func tapOnCell(architecture: Architecture?)
    func getArchitectureImageDimensions(index: Int) -> CGSize
    
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
    
    func getArchitectureImageDimensions(index: Int) -> CGSize {
        var dimensions: CGSize?
//        if let imageName = architecture?[index].previewImageFileNames?.first,
//            let imageURL = URL(string: imageName, relativeTo: dataProvider.imagesFolder) {
//            
//            dimensions = view.getDimensionsOfImage(url: imageURL)
//        }
        return dimensions ?? CGSize(width: 1, height: 1)
    }
    
    
    
}


