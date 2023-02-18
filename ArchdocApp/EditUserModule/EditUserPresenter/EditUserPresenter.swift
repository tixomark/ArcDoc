//
//  EditUserPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 2/15/23.
//

import Foundation

protocol EditUserViewProtocol: AnyObject {
    var presenter: EditUserPresenterProtocol! {get}
    func selfDismiss()
}

protocol EditUserPresenterProtocol {
    init(view: EditUserViewProtocol, router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol)
    
    func userDidTapOnChangeImageButton() 
    func userDidTapOnRow(atIndexPath indexPath: IndexPath)
    func userDidTapOnDone()
    func userDidTapOnCancel()
}

class EditUserPresenter: EditUserPresenterProtocol {

    weak var view: EditUserViewProtocol!
    let dataProvider: DataProviderProtocol!
    let router: RouterProtocol!
    let authService: FirebaseAuthProtocol!
  
    required init(view: EditUserViewProtocol, router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol) {
        self.view = view
        self.dataProvider = dataProvider
        self.router = router
        self.authService = authService
    }
    
    deinit {
        print("deinit 'EditUserPresenter'")
    }
    
    func userDidTapOnChangeImageButton() {
        
    }
    
    
    func userDidTapOnRow(atIndexPath indexPath: IndexPath) {
        if indexPath.section == 3 && indexPath.row == 0 {
            guard authService.signOut() else { return }
            view.selfDismiss()
        }
    }
    
    func userDidTapOnDone() {
        
    }
    
    func userDidTapOnCancel() {
        view.selfDismiss()
    }
    
    
}
