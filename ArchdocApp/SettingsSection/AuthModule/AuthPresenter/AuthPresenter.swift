//
//  AuthPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 2/13/23.
//

import Foundation

protocol AuthControllerProtocol {
    var presenter: AuthPresenterProtocol! {get}
}

protocol AuthViewProtocol: AnyObject {
    var presenter: AuthPresenterProtocol! {get}
    
    func updateUIToMatchAuth(option: AuthOption)
    func updateAuthButtonAccordingToAuthAvalability(_ option: Bool)
    func setCanEditPasswordConfirmationField(_ canEdit: Bool)
    func showAlertUsing(_ data: (String, String))
}

protocol AuthPresenterProtocol {
    init(view: AuthViewProtocol)
    func navigationControllerDisappeared()
    
    func didTapOnAuthOptionButton(ofType buttonType: AuthOption)
    func didTapOnAuthenticationButton()

    func userDidFinishEditingTextField()
    func userIsEditingEmail(_ email: String, _ validationResult: (Validation) -> ())
    func userIsEditingPassword(_ password: String, _ validationResult: (Validation, Validation) -> ())
    func userIsEditingConfirmationPassword(_ password: String, _ validationResult: (Validation) -> ())
}

enum AuthOption {
    case logIn, signUp
}

extension AuthPresenter: ServiceObtainableProtocol {
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

class AuthPresenter: AuthPresenterProtocol {
    var router: RouterProtocol!
    var dataProvider: DataProviderProtocol!
    var authService: FirebaseAuthProtocol!
    var firestore: FirestoreDBProtocol!
    
    weak var view: AuthViewProtocol!
    var currentAuthOption = AuthOption.logIn
    var email: String?
    var password: String?
    var confPassword: String?
    
    required init(view: AuthViewProtocol) {
        self.view = view
    }
    
    deinit {
        print("deinit 'AuthPresenter'")
    }
    
    func navigationControllerDisappeared() {
        router.dismissAuthenticationModule()
    }
    
    func didTapOnAuthOptionButton(ofType authType: AuthOption) {
        guard authType != currentAuthOption else { return }
        currentAuthOption = authType
        view.updateUIToMatchAuth(option: currentAuthOption)
        if currentAuthOption == .logIn {
            confPassword = nil
        }
        let isAuthAvalable = authenticationIsPossible()
        view.updateAuthButtonAccordingToAuthAvalability(isAuthAvalable)
    }
    
    func didTapOnAuthenticationButton() {
        guard authenticationIsPossible() else { return }
        view.updateAuthButtonAccordingToAuthAvalability(false)
        
        switch currentAuthOption {
        case .signUp:
            authService.createUser(withEmail: email!, password: password!) { [self] error in
                guard error == nil, let uid = authService.curentUserID else {
                    view.updateAuthButtonAccordingToAuthAvalability(true)
                    let alertData = AuthAlertData(error!).dataForAlert()
                    view.showAlertUsing(alertData)
                    return
                }
                let username = createUsernameFrom(email: email!)
                let data = ["email" : email!, "username" : username]
                firestore.setUserData(using: data, forUserID: uid) { [self] success in
                    guard success else { return }
                    router.showEmailVerificationModule()
                }
            }
        case .logIn:
            authService.signIn(withEmail: email!, password: password!) { [self] error in
                if error == nil {
                    router.dismissAuthenticationModule()
                } else {
                    let alertData = AuthAlertData(error!).dataForAlert()
                    view.showAlertUsing(alertData)
                    view.updateAuthButtonAccordingToAuthAvalability(true)
                }
            }
        }
    }
    
    private func createUsernameFrom(email: String) -> String {
        guard let atPosition = email.firstIndex(of: "@") else { return email }
        let size = email.distance(from: email.startIndex, to: atPosition)
        let username = String(email.dropLast(email.count - size))
        return username
    }
    
    func userDidFinishEditingTextField() {
        let isAuthPossible = authenticationIsPossible()
        view.updateAuthButtonAccordingToAuthAvalability(isAuthPossible)
    }
    
    func userIsEditingEmail(_ email: String, _ validationResult: (Validation) -> ()) {
        var result: Validation = .none
        if email != "" {
            let isValid = email.isValidEmail()
            self.email = isValid ? email : nil
            view.setCanEditPasswordConfirmationField(isValid && password != nil)
            result = isValid ? .none : .emailFailure
        }
        validationResult(result)
    }
    
    func userIsEditingPassword(_ password: String, _ validationResult: (Validation, Validation) -> ()) {
        var result: Validation = .none
        var confPasswordResult: Validation = .none
        
        if password != "" {
            if currentAuthOption == .signUp {
                let isValid = password.isValidPassword()
                self.password = isValid ? password : nil
                view.setCanEditPasswordConfirmationField(email != nil && isValid)
                result = isValid ? .none : .passwordHint
                
                if self.password != confPassword && confPassword != nil {
                    confPasswordResult = .passwordsDontMatch
                }
            } else {
                self.password = password
            }
        }
        validationResult(result, confPasswordResult)
    }
    
    func userIsEditingConfirmationPassword(_ password: String, _ validationResult: (Validation) -> ()) {
        var result: Validation = .none
        if currentAuthOption == .signUp && password != "" {
            let isValid = (self.password == password)
            self.confPassword = password
            result = isValid ? .none : .passwordsDontMatch
        }
        validationResult(result)
    }

    private func authenticationIsPossible() -> Bool {
        var isAuthPossible = false
        if email != nil, password != nil {
            switch currentAuthOption {
            case .signUp:
                if confPassword == password { isAuthPossible = true }
            case .logIn:
                isAuthPossible = true
            }
        }
        return isAuthPossible
    }
    
}
