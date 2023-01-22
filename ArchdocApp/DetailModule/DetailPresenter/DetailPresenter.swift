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
}

protocol DetailPresenterProtocol {
    init(view: DetailViewProtocol, architectureItem: Architecture?, router: RouterProtocol)
    var architectureItem: Architecture? {get set}
    func setUIData()
}

class DetailPresenter: DetailPresenterProtocol {
    
    weak var view: DetailViewProtocol!
    var architectureItem: Architecture?
    var router: RouterProtocol?
    
    required init(view: DetailViewProtocol, architectureItem: Architecture?, router: RouterProtocol) {
        self.view = view
        self.architectureItem = architectureItem
        self.router = router
        
    }
    
    func setUIData() {
        view.setUIData(architectureItem: architectureItem)
    }
    
    
}
