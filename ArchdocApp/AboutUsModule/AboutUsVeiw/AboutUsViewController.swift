//
//  AboutUsViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/23/23.
//

import UIKit

class AboutUsViewController: UIViewController {

    var presenter: AboutUsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}


extension AboutUsViewController: AboutUsViewProtocol {
    
}
