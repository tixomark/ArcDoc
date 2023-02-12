//
//  SettingsPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 2/12/23.
//

import Foundation

protocol SettingsControllerProtocol {
    var presenter: SettingsPresenterProtocol! {get}
}

protocol SettingsViewProtocol {
    var presenter: SettingsPresenterProtocol! {get}
}

protocol SettingsPresenterProtocol {
    init(view: SettingsViewProtocol, dataProvider: DataProviderProtocol, router: RouterProtocol)
    func didTapOnCell(atIndex: IndexPath)
}

class SettingsPresenter: SettingsPresenterProtocol {
    let view: SettingsViewProtocol!
    let dataProvider: DataProviderProtocol!
    let router: RouterProtocol!
    
    required init(view: SettingsViewProtocol, dataProvider: DataProviderProtocol, router: RouterProtocol) {
        self.view = view
        self.dataProvider = dataProvider
        self.router = router
    }
    
    func didTapOnCell(atIndex: IndexPath) {
        router.showSettingsAboutUsModule()
    }
    
    
    
}
