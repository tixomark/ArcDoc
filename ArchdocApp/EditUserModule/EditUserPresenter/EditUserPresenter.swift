//
//  EditUserPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 2/15/23.
//

import Foundation

protocol EditUserViewProtocol: AnyObject {
    var presenter: EditUserPresenterProtocol! {get}
    
    func setAppearanceUsingData(_ user: User)
    func selfDismiss()
}

protocol EditUserPresenterProtocol {
    init(view: EditUserViewProtocol, router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol)
    
    func userDidTapOnChangeImageButton() 
    func userDidTapOnRow(atIndexPath indexPath: IndexPath)
    func userDidTapOnDone()
    func userDidTapOnCancel()
    
    func textFieldValueChanged(_ text: String, inCellAtIndexPath indexPath: IndexPath)
    
    func configureViewAppearance()
    func getDataForCell(atIndexPath indexPath: IndexPath) -> String?
    
}

class EditUserPresenter: EditUserPresenterProtocol {

    weak var view: EditUserViewProtocol!
    let dataProvider: DataProviderProtocol!
    let router: RouterProtocol!
    let authService: FirebaseAuthProtocol!
    let firestore: FirestoreDBProtocol!
    
    var user: User?
  
    required init(view: EditUserViewProtocol, router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol, firestore: FirestoreDBProtocol) {
        self.view = view
        self.dataProvider = dataProvider
        self.router = router
        self.authService = authService
        self.firestore = firestore
    }
    
    deinit {
        print("deinit 'EditUserPresenter'")
    }
    
    func configureViewAppearance() {
        guard let uid = authService.curentUserID else { return }
        firestore.getUserDataFor(userID: uid) { user in
            guard let user = user else { return }
            self.user = user
            self.view.setAppearanceUsingData(user)
            print("configured view according to user data")
        }
    }
    
    func getDataForCell(atIndexPath indexPath: IndexPath) -> String? {
        guard let user = user else { return nil}
        var cellData: String?
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cellData = user.firstName
            case 1:
                cellData = user.lastName
            default:
                return cellData
            }
        case 1:
            cellData = user.bio
        case 2:
            switch indexPath.row {
            case 0:
                cellData = user.email
            case 1:
                cellData = user.username
            default:
                return cellData
            }
        case 3:
            cellData = ""
        default:
            return cellData
        }
        return cellData
    }
    
    func textFieldValueChanged(_ text: String, inCellAtIndexPath indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                user?.firstName = text
            case 1:
                user?.lastName = text
            default:
                return
            }
        case 1:
            user?.bio = text
        default:
            return
        }
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
        
        let fieldsToUpdate: [UserFields] = [.firstName, .lastName, .bio]
        guard let dataToUpdate = user?.makeDict(usingFields: fieldsToUpdate), let uid = authService.curentUserID else { return }
        print(dataToUpdate)
        firestore.updateUserData(using: dataToUpdate, forUserID: uid) { success in
            print(success)
            guard success else {
                print("can not update data")
                return
            }
            self.view.selfDismiss()
        }
    }
    
    func userDidTapOnCancel() {
        view.selfDismiss()
    }
}
