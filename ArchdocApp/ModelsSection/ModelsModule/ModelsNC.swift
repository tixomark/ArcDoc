//
//  ModelsNavigationController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/12/23.
//

import UIKit

class ModelsNavigationController: UINavigationController {

    var presenter: ModelsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.backgroundColor = .green
        // Do any additional setup after loading the view.
    }

}

extension ModelsNavigationController: ModelsControllerProtocol {

}
