//
//  EnterUserDetailPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 2/23/23.
//

import Foundation

protocol EnterUserDetailsViewProtocol: AnyObject {
    var presenter: EnterUserDetailsPresenterProtocol! {get}
    
    func setDoneButtonIsEnabled(to value: Bool)
}

protocol EnterUserDetailsPresenterProtocol {
    init(view: EnterUserDetailsViewProtocol)
    
    func textFieldValueChanged(_ text: String, inCellAtIndexPath indexPath: IndexPath)
    func userDidTapOnDone()
}

extension EnterUserDetailsPresenter: ServiceObtainableProtocol {
    var neededServices: [Service] {
        return [.router, .firestore, .authService]
    }
    
    func getServices(_ services: [Service : ServiceProtocol]) {
        self.router = (services[.router] as! RouterProtocol)
        self.firestore = (services[.firestore] as! FirestoreDBProtocol)
        self.authService = (services[.authService] as! FirebaseAuthProtocol)
    }
}

class EnterUserDetailsPresenter: EnterUserDetailsPresenterProtocol {
    var router: RouterProtocol!
    var firestore: FirestoreDBProtocol!
    var authService: FirebaseAuthProtocol!
    
    weak var view: EnterUserDetailsViewProtocol!
    var user: User?
    
    required init(view: EnterUserDetailsViewProtocol) {
        self.view = view
        self.user = User()
    }
    
    func textFieldValueChanged(_ text: String, inCellAtIndexPath indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                user?.firstName = text
                validateFirstNameField()
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
    
    private func validateFirstNameField()  {
        if let user = user, user.firstName.count != 0 {
            view.setDoneButtonIsEnabled(to: true)
        } else {
            view.setDoneButtonIsEnabled(to: false)
        }
    }

    func userDidTapOnDone() {
        let fieldsToUpdate: [UserFields] = [.firstName, .lastName, .bio]
        guard let dataToUpdate = user?.makeDict(usingFields: fieldsToUpdate), let uid = authService.curentUserID else { return }
        print(dataToUpdate)
        firestore.updateUserData(using: dataToUpdate, forUserID: uid) { success in
            guard success else {
                print("can not update data")
                return
            }
            self.router.dismissAuthenticationModule()
        }
    }
}
