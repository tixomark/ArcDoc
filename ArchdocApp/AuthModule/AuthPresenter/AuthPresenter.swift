//
//  AuthPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 2/13/23.
//

import Foundation

protocol AuthViewProtocol: AnyObject {
    var presenter: AuthPresenterProtocol! {get}
    func updateUIToMatchAuth(option: AuthOption)
    func updateAuthButtonAccordingToAuthAvalability(_ option: Bool)
    func setCanEditPasswordConfirmationField(_ canEdit: Bool)
    func selfDismiss()
}

protocol AuthPresenterProtocol {
    init(view: AuthViewProtocol, router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol)
    
    func didTapOnAuthOptionButton(ofType buttonType: AuthOption)
    func didTapOnAuthenticationButton()

    func userDidFinishEditingTextField()
    func userIsEditingEmail(_ email: String, _ validationResult: (Bool) -> ())
    func userIsEditingPassword(_ password: String, _ validationResult: (Bool) -> ())
    func userIsEditingConfirmationPassword(_ password: String, _ validationResult: (Bool) -> ())
    func revalidateConfPassword() -> Bool
}

protocol AuthPresenterAuthResultDelegate: AnyObject {
    func userFinishedAuthentication(usingOption: AuthOption, success: Bool)
}
extension AuthPresenterAuthResultDelegate {
    func userFinishedAuthentication(usingOption: AuthOption, success: Bool? = true) {}
}


enum AuthOption {
    case logIn, signIn
}

class AuthPresenter: AuthPresenterProtocol {
    
    weak var view: AuthViewProtocol!
    var router: RouterProtocol!
    var dataProvider: DataProviderProtocol!
    var authService: FirebaseAuthProtocol!
    
    weak var delegate: AuthPresenterAuthResultDelegate!
    
    var currentAuthOption = AuthOption.signIn
    var email: String?
    var password: String?
    var confPassword: String?
    
    required init(view: AuthViewProtocol, router: RouterProtocol, dataProvider: DataProviderProtocol, authService: FirebaseAuthProtocol) {
        self.view = view
        self.router = router
        self.dataProvider = dataProvider
        self.authService = authService
    }
    
    deinit {
        print("deinit 'AuthPresenter'")
    }
    
    func didTapOnAuthOptionButton(ofType authType: AuthOption) {
        view.updateUIToMatchAuth(option: authType)
        currentAuthOption = authType
        if authType == .signIn {
            confPassword = nil
            
        }
        let isAuthAvalable = authenticationIsPossible()
        view.updateAuthButtonAccordingToAuthAvalability(isAuthAvalable)
    }
    
    func didTapOnAuthenticationButton() {
        guard authenticationIsPossible() else { return }
        view.updateAuthButtonAccordingToAuthAvalability(false)
        
        switch currentAuthOption {
        case .logIn:
            authService.createUser(withEmail: email!, password: password!) { [self] error in
                if error == nil {
                    delegate.userFinishedAuthentication(usingOption: currentAuthOption)
                    view.selfDismiss()
                } else {
                    print(error!.localizedDescription)
                    view.updateAuthButtonAccordingToAuthAvalability(true)
                }
            }
        case .signIn:
            authService.signIn(withEmail: email!, password: password!) { [self] error in
                if error == nil {
                    delegate.userFinishedAuthentication(usingOption: currentAuthOption)
                    view.selfDismiss()
                } else {
                    print(error!.localizedDescription)
                    view.updateAuthButtonAccordingToAuthAvalability(true)
                }
            }
        }
    }
    
    func userDidFinishEditingTextField() {
        let isAuthPossible = authenticationIsPossible()
        view.updateAuthButtonAccordingToAuthAvalability(isAuthPossible)
    }
    
    func userIsEditingEmail(_ email: String, _ validationResult: (Bool) -> ()) {
        if currentAuthOption == .logIn {

        var isValid = email.isValidEmail()
        self.email = isValid ? email : nil
        view.setCanEditPasswordConfirmationField(isValid && password != nil)
//        if currentAuthOption == .signIn {
//            isValid = true
            validationResult(isValid)
        }
    }
    func userIsEditingPassword(_ password: String, _ validationResult: (Bool) -> ()) {
        if currentAuthOption == .logIn {
        var isValid = password.isValidPassword()
        self.password = isValid ? password : nil
        view.setCanEditPasswordConfirmationField(email != nil && isValid)
//            isValid = true
            validationResult(isValid)
        }
    }
    func userIsEditingConfirmationPassword(_ password: String, _ validationResult: (Bool) -> ()) {
        if currentAuthOption == .logIn {

        var isValid = (self.password == password)
        self.confPassword = isValid ? password : nil
//        if currentAuthOption == .signIn {
//            isValid = true
            validationResult(isValid)
        }
    }
    
    func revalidateConfPassword() -> Bool {
        return password == confPassword
    }
    
    private func authenticationIsPossible() -> Bool {
        var isAuthPossible = false
        if email != nil, password != nil {
            switch currentAuthOption {
            case .logIn:
                if confPassword == password { isAuthPossible = true }
            case .signIn:
                isAuthPossible = true
            }
        }
        return isAuthPossible
    }
    
}
