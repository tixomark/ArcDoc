//
//  DetailViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/22/23.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var mainImageView: UIImageView!
    
    
    var presenter: DetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        presenter.setUIData()
        // Do any additional setup after loading the view.
    }
    deinit {
        print("deinit")
    }
    

}

extension DetailViewController: DetailViewProtocol {
    func setUIData(architectureItem: Architecture?) {
        mainImageView.image = UIImage(named: presenter.architectureItem?.imageName ?? "noImage")
        
    }
    
    
}
