//
//  AuthNavigationController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/23/23.
//

import UIKit

class AuthNavigationController: UINavigationController {
    var presenter: AuthPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.isEnabled = false
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.navigationControllerDisappeared()
    }

}

extension AuthNavigationController: AuthControllerProtocol {
    
}
