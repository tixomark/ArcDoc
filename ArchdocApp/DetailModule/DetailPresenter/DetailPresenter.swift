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
    func setLoading(state: LoadingState)
}

protocol DetailPresenterProtocol {
    var architectureItem: Architecture? {get set}
    var router: RouterProtocol? {get}
    var dataProvider: DataProviderProtocol? {get}
    
    init(view: DetailViewProtocol, architectureItem: Architecture?, router: RouterProtocol, dataProvider: DataProviderProtocol)
    func setUIData()
    func didTapOn3DViewButton()
}

enum LoadingState {
    case yetToBeLoaded
    case loading(Float)
    case done
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
        self.dataProvider?.delegate = self
        
    }
    
    deinit {
        print("deinit 'DetailPresenter'")
    }
    
    func setUIData() {
        view.setUIData(architectureItem: architectureItem)
        if architectureItem?.modelURL != nil {
            view.setLoading(state: .done)
        } else {
            view.setLoading(state: .yetToBeLoaded)
        }
    }
    
    func didTapOn3DViewButton() {
        if let modelURL = architectureItem?.modelURL {
            router?.showModelTriDSceneModule(modelUrl: modelURL)
        } else if let archItem = architectureItem {
            dataProvider?.loadUSDZModelFor(archItem)
        }
    }
    

    
}

extension DetailPresenter: DataProviderDownloadProgressDelegate {
    func didFinishLoadingModelOf(architecture: Architecture) {
        DispatchQueue.main.async {
            self.view.setLoading(state: .done)
        }
    }
    
    func currentProgress(_ progress: Float, ofDownloading arch: Architecture) {
        DispatchQueue.main.async {
            self.view.setLoading(state: .loading(progress))
        }
    }
}

