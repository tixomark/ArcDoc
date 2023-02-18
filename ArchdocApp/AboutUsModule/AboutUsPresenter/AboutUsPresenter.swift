//
//  AboutUsPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/23/23.
//

import Foundation

protocol AboutUsViewProtocol: AnyObject {
    var presenter: AboutUsPresenterProtocol! {get}
}

protocol AboutUsPresenterProtocol {
    init(view: AboutUsViewProtocol, router: RouterProtocol)
}

class AboutUsPresenter: AboutUsPresenterProtocol {
    
    weak var view: AboutUsViewProtocol?
    var router: RouterProtocol?
    var aboutUsData: AboutUs?
    
    required init(view: AboutUsViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        
    }
    
    deinit {
        print("deinit 'AboutUsPresenter'")
    }
}

