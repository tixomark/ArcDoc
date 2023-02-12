//
//  SettingsNavigationController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/12/23.
//

import UIKit

class SettingsNavigationController: UINavigationController {
    
    var presenter: SettingsPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationBar.prefersLargeTitles = true
        navigationBar.backgroundColor = .red
    }


}

extension SettingsNavigationController: SettingsControllerProtocol {
    
}
