//
//  ScreenSelectorPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 1/24/23.
//

import Foundation

protocol ScreenSelectorViewProtocol: AnyObject {
    var presenter: ScreenSelectorPresenterProtocol! {get}
    func reloadTabBarItems()
}

protocol ScreenSelectorPresenterProtocol {
    init(view: ScreenSelectorViewProtocol)
    
    var tabBarItems: [TabBarItem]? {get set}
    func viewLoaded()
    func tapOnItem(index: Int)
}

extension ScreenSelectorPresenter: ServiceObtainableProtocol {
    var neededServices: [Service] {
        return [.router, .dataProvider]
    }
    
    func getServices(_ services: [Service : ServiceProtocol]) {
        self.router = (services[.router] as! RouterProtocol)
        self.dataProvider = (services[.dataProvider] as! DataProviderProtocol)
    }
}

class ScreenSelectorPresenter: ScreenSelectorPresenterProtocol {
    var router: RouterProtocol!
    var dataProvider: DataProviderProtocol!
    
    weak var view: ScreenSelectorViewProtocol!
    var tabBarItems: [TabBarItem]?
    
    required init(view: ScreenSelectorViewProtocol) {
        self.view = view
    }
    
    deinit {
        print("deinit 'ScreenSelectorPresenter'")
    }
    
    func viewLoaded() {
        tabBarItems = dataProvider.getTabBatItems()
        view.reloadTabBarItems()
    }
    
    func tapOnItem(index: Int) {
        switch index {
        case 0:
            router.showModelsModule()
        case 1:
            print(index)
        case 2:
            print(index)
        case 3:
            router.showSettingsModule()
        default:
            print("Did not find module to show after tapping on ScreenSelector")
        }
    }
    
    
    
}
