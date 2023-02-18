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

protocol SettingsViewProtocol: AnyObject {
    var presenter: SettingsPresenterProtocol! {get}
    func changeHeaderAccordingTo(_ state: UserAuthState)
}

enum UserAuthState {
    case noUser, userSignedIn
}

protocol SettingsPresenterProtocol {
    init(view: SettingsViewProtocol, router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol)
    func requestHeaderUpdate()
    func didTapOnCell(atIndex: IndexPath)
    func didTapOnEditButton()
    func didTapOnLoginButton()
}

class SettingsPresenter: SettingsPresenterProtocol {

    weak var view: SettingsViewProtocol!
    let dataProvider: DataProviderProtocol!
    let router: RouterProtocol!
    let authService: FirebaseAuthProtocol!
    
    required init(view: SettingsViewProtocol, router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol) {
        self.view = view
        self.dataProvider = dataProvider
        self.router = router
        self.authService = authService
    }
    
    deinit {
        print("deinit 'SettingsPresenter'")
    }
    
    func requestHeaderUpdate() {
        switch authService.isUserLoggedIn {
        case true:
            view.changeHeaderAccordingTo(.userSignedIn)
        case false:
            view.changeHeaderAccordingTo(.noUser)
        }
    }
    
    func didTapOnCell(atIndex: IndexPath) {
        switch atIndex.row {
        case 0:
            router.showAboutUsModule()
        case 1:
            return
        default:
            print("Somehow user did tap on nonexistent cell")
        }
    }
    
    func didTapOnLoginButton() {
        guard !authService.isUserLoggedIn else { return }
        router.showAuthenticationModule(dataProvider: dataProvider,
                                        authService: authService) { authPresenter in
            authPresenter.delegate = self
        }
    }
    
    func didTapOnEditButton() {
        guard authService.isUserLoggedIn else { return }
        router.showEditUserModule(dataProvider: dataProvider,
                                  authService: authService)
    }
    
    
}

extension SettingsPresenter: AuthPresenterAuthResultDelegate {
    func userFinishedAuthentication(usingOption: AuthOption, success: Bool) {
        requestHeaderUpdate()
    }
    
    
}
