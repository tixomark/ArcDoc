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
    init(view: EditUserViewProtocol)
    
    func userDidTapOnChangeImageButton() 
    func userDidTapOnRow(atIndexPath indexPath: IndexPath)
    func userDidTapOnDone()
    func userDidTapOnCancel()
    
    func textFieldValueChanged(_ text: String, inCellAtIndexPath indexPath: IndexPath)
    
    func configureViewAppearance()
    func getDataForCell(atIndexPath indexPath: IndexPath) -> String?
    
}

extension EditUserPresenter: ServiceObtainableProtocol {
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

class EditUserPresenter: EditUserPresenterProtocol {
    var dataProvider: DataProviderProtocol!
    var router: RouterProtocol!
    var authService: FirebaseAuthProtocol!
    var firestore: FirestoreDBProtocol!
    
    weak var view: EditUserViewProtocol!
    var user: User?
  
    required init(view: EditUserViewProtocol) {
        self.view = view
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
            guard success else { return }
            self.view.selfDismiss()
        }
    }
    
    func userDidTapOnCancel() {
        view.selfDismiss()
    }
}
