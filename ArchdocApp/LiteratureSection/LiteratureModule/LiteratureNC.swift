//
//  LiteratureViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 3/4/23.
//

import UIKit

class LiteratureNavigationController: UINavigationController {

    var presenter: LiteraturePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension LiteratureNavigationController: LiteratureControllerProtocol {
    
}
