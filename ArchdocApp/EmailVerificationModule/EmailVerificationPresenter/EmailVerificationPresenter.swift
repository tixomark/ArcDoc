//
//  EmailVerificationPresenter.swift
//  ArchdocApp
//
//  Created by tixomark on 2/23/23.
//

import Foundation

protocol EmailVerificationViewProtocol: AnyObject {
    var presenter: EmailVerificationPresenterProtocol! {get}
    func updateLabelInfo(userEmail: String?)
}

protocol EmailVerificationPresenterProtocol {
    init(view: EmailVerificationViewProtocol)
    
    func viewLoaded()
}

extension EmailVerificationPresenter: ServiceObtainableProtocol {
    var neededServices: [Service] {
        return [.router, .authService, .firestore]
    }
    
    func getServices(_ services: [Service : ServiceProtocol]) {
        self.router = (services[.router] as! RouterProtocol)
        self.authService = (services[.authService] as! FirebaseAuthProtocol)
        self.firestore = (services[.firestore] as! FirestoreDBProtocol)
    }
}

class EmailVerificationPresenter: EmailVerificationPresenterProtocol {
    var router: RouterProtocol!
    var authService: FirebaseAuthProtocol!
    var firestore: FirestoreDBProtocol!
    
    weak var view: EmailVerificationViewProtocol!
    var timer: Timer!
    
    required init(view: EmailVerificationViewProtocol) {
        self.view = view
    }
    
    deinit {
        if timer != nil {
            timer.invalidate()
        }
        timer = nil
        print("deinit 'EmailVerificationPresenter'")
    }
    
    func viewLoaded() {
        view.updateLabelInfo(userEmail: authService.user?.email)
        sendEmailVerification()
        waitForEmailVerification()
    }
    
    func sendEmailVerification() {
        authService.sendEmailVerification { error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
    }
    
    func waitForEmailVerification() {
        guard timer == nil else { return }
        timer = Timer(timeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let tempSelf = self, let user = tempSelf.authService.user else { return }
            if user.isEmailVerified {
                tempSelf.timer.invalidate()
                tempSelf.timer = nil
                tempSelf.router.showEnterUserDetailsModule()
            } else {
                tempSelf.authService.reloadUser { _ in }
            }
        })
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
    }
}
