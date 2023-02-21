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
    init(view: SettingsViewProtocol, router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol)
    
    func viewLoaded()
    func requestHeaderUpdate()

    func didTapOnCell(atIndex: IndexPath)
    func didTapOnEditButton()
    func didTapOnLoginButton()
}

class SettingsPresenter: SettingsPresenterProtocol, CustomStringConvertible {
    var description: String = "SettingsPresenter"
    
    weak var view: SettingsViewProtocol!
    let dataProvider: DataProviderProtocol!
    let router: RouterProtocol!
    let authService: FirebaseAuthProtocol!
    let firestore: FirestoreDBProtocol!
    
    required init(view: SettingsViewProtocol, router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol) {
        self.view = view
        self.dataProvider = dataProvider
        self.router = router
        self.authService = authService
        self.firestore = firestore
        
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
//                firestore.getUserDataFor(userID: user.uid) { user in
//                    guard let user = user else { return }
//                    self.view.updateHeaderDataUsing(userData: user)
//                }
//                guard let uid = authService.curentUserID else { return }
                firestore.addUserSnapshotListenerFor(listenerOwner: self, userID: user.uid) { user in
                    guard let user = user else { return }
                    self.view.updateHeaderDataUsing(userData: user)
                }
            } else {
                firestore.removeUserSnapshotListener(of: self)
            }
            
        }
        
        
    }
    
    func requestHeaderUpdate() {
//        guard view.headerViewState != authService.authState else { return }
//        view.changeHeaderConfigurationAccordingTo(authService.authState)
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
        router.showAuthenticationModule(dataProvider: dataProvider,
                                        authService: authService,
                                        firestore: firestore)
    }
    
    func didTapOnEditButton() {
        guard authService.isUserLoggedIn else { return }
        router.showEditUserModule(dataProvider: dataProvider,
                                  authService: authService,
                                  firestore: firestore)
    }
}
