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
    var headerViewState: UserAuthState! {get}
    func changeHeaderConfigurationAccordingTo(_ state: UserAuthState)
    func updateHeaderDataUsing(userData data: User)
}

protocol SettingsPresenterProtocol {
    init(view: SettingsViewProtocol)
    
    func viewLoaded()

    func didTapOnCell(atIndex: IndexPath)
    func didTapOnEditButton()
    func didTapOnLoginButton()
}

extension SettingsPresenter: ServiceObtainableProtocol {
    var neededServices: [Service] {
        return [.router, .dataProvider, .authService, .firestore]
    }
    
    func getServices(_ services: [Service : ServiceProtocol]) {
        self.dataProvider = (services[.dataProvider] as! DataProviderProtocol)
        self.router = (services[.router] as! RouterProtocol)
        self.authService = (services[.authService] as! FirebaseAuthProtocol)
        self.firestore = (services[.firestore] as! FirestoreDBProtocol)
    }
}

class SettingsPresenter: SettingsPresenterProtocol, CustomStringConvertible {
    var description: String = "SettingsPresenter"
    
    var dataProvider: DataProviderProtocol!
    var router: RouterProtocol!
    var authService: FirebaseAuthProtocol!
    var firestore: FirestoreDBProtocol!
    
    weak var view: SettingsViewProtocol!
    
    required init(view: SettingsViewProtocol) {
        self.view = view
    }
    
    deinit {
        authService.removeAuthListener(of: self)
        firestore.removeUserSnapshotListener(of: self)
        print("deinit 'SettingsPresenter'")
    }
    
    func viewLoaded() {
        authService.addAuthListenerFor(listenerOwner: self) { [self] user in
            view.changeHeaderConfigurationAccordingTo(user != nil ? .userSignedIn : .noUser)
            if let user = user {
                firestore.addUserSnapshotListenerFor(listenerOwner: self, userID: user.uid) { user in
                    guard let user = user else { return }
                    self.view.updateHeaderDataUsing(userData: user)
                }
            } else {
                firestore.removeUserSnapshotListener(of: self)
            }
        }
    }
    
    func didTapOnCell(atIndex: IndexPath) {
        switch atIndex.row {
        case 0:
            router.showAboutUsModule()
        case 1:
            authService.sendEmailVerification { error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
            }
        case 2:

            return
        default:
            print("Somehow user did tap on nonexistent cell")
        }
    }
    
    func didTapOnLoginButton() {
        guard !authService.isUserLoggedIn else { return }
        router.showAuthenticationModule()
    }
    
    func didTapOnEditButton() {
        guard authService.isUserLoggedIn else { return }
        router.showEditUserModule()
    }
}
