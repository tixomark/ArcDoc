//
//  DetailViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/22/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var architectureNameLabel: UILabel!
    @IBOutlet weak var architectureDescrLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    var presenter: DetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.backgroundColor = .white
        mainImageView.contentMode = .scaleAspectFit
        
        presenter.setUIData()
        // Do any additional setup after loading the view.
    }
    deinit {
        print("deinit detailVC")
    }
    
    
    @IBAction func tap3DModelButton(_ sender: Any) {
        presenter.router?.showTriDSceneModule()
    }
    

}

extension DetailViewController: DetailViewProtocol {
    func setUIData(architectureItem: Architecture?) {
        let image = UIImage(named: presenter.architectureItem?.imageName ?? "noImage")
        mainImageView.image = image
        
        let aspectRatio = Float(image!.size.height) / Float(image!.size.width)
        let newImageViewHeight = aspectRatio * Float(self.view.bounds.width)
        imageHeightConstraint.constant = CGFloat(newImageViewHeight)
        
        architectureNameLabel.text = presenter.architectureItem?.title ?? "Placeholder Title"
        architectureDescrLabel.text = presenter.architectureItem?.detail ?? "No description for this architecture"
        
    }
    
    
}
