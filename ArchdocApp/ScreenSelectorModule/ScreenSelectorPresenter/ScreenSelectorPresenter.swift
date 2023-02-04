//
//  ScreenSelectorPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/24/23.
//

import Foundation

protocol ScreenSelectorViewProtocol: AnyObject {
    var presenter: ScreenSelectorPresenterProtocol! {get}
//    func didSelectViewAt(index: Int)
}

protocol ScreenSelectorPresenterProtocol {
    init(view: ScreenSelectorViewProtocol, dataProvider: DataProviderProtocol, router: RouterProtocol)
    var tabBarItems: [TabBarItem]? {get set}
    func getTabBarItems()
    func tapOnItem(index: Int)
    
}

class ScreenSelectorPresenter: ScreenSelectorPresenterProtocol {
    
    weak var view: ScreenSelectorViewProtocol?
    let router: RouterProtocol!
    let dataProvider: DataProviderProtocol?
    var tabBarItems: [TabBarItem]?
    
    required init(view: ScreenSelectorViewProtocol, dataProvider: DataProviderProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
        self.dataProvider = dataProvider
        getTabBarItems()
        
    }
    
    func getTabBarItems() {
        tabBarItems = dataProvider?.getTabBatItems()
    }
    
    func tapOnItem(index: Int) {
        switch index {
        case 0:
            router.showMainModule()
        case 1:
            print(index)
        case 2:
            print(index)
        case 3:
            
            router?.showAboutUsModule()
        default:
            router.showMainModule()
            
        }
    }
    
    
    
}
