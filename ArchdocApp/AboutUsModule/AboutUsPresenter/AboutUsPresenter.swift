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
    init(view: AboutUsViewProtocol)
}

extension AboutUsPresenter: ServiceObtainableProtocol {
    var neededServices: [Service] {
        return [.router]
    }
    
    func getServices(_ services: [Service : ServiceProtocol]) {
        self.router = (services[.router] as! RouterProtocol)
    }
}

class AboutUsPresenter: AboutUsPresenterProtocol {
    var router: RouterProtocol?
    
    weak var view: AboutUsViewProtocol?
    var aboutUsData: AboutUs?
    
    required init(view: AboutUsViewProtocol) {
        self.view = view
    }
    
    deinit {
        print("deinit 'AboutUsPresenter'")
    }
}

