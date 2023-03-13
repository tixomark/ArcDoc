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
    
    init(view: DetailViewProtocol, architectureItem: Architecture?)
    func setUIData()
    func didTapOn3DViewButton()
}

enum LoadingState {
    case yetToBeLoaded
    case loading(Float)
    case done
}

extension DetailPresenter: ServiceObtainableProtocol {
    var neededServices: [Service] {
        return [.router, .dataProvider]
    }
    
    func getServices(_ services: [Service : ServiceProtocol]) {
        self.dataProvider = (services[.dataProvider] as! DataProviderProtocol)
        self.router = (services[.router] as! RouterProtocol)
        self.dataProvider?.delegate = self
    }
}

class DetailPresenter: DetailPresenterProtocol {
    var router: RouterProtocol?
    var dataProvider: DataProviderProtocol?
    
    weak var view: DetailViewProtocol!
    var architectureItem: Architecture?
    
    required init(view: DetailViewProtocol, architectureItem: Architecture?) {
        self.view = view
        self.architectureItem = architectureItem
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

