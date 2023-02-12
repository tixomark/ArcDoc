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
    @IBOutlet weak var modelButton: UIButton!
    
    var presenter: DetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        setUpUI()
        presenter.setUIData()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
////        self.navigationController?.navigationBar.backgroundColor = .systemBackground
//    }
//    
    func setUpUI() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.contentMode = .scaleAspectFit
    }
    
    deinit {
        print("deinit DetailViewController")
    }

    @IBAction func tap3DModelButton(_ sender: Any) {
        presenter.didTapOn3DViewButton()
    }

}

extension DetailViewController: DetailViewProtocol {
    func setUIData(architectureItem: Architecture?) {
        guard let arch = architectureItem else { return }
        
        let image = (arch.previewImages?.first ?? UIImage(named: "noImage"))!
        mainImageView.image = image
        
        let aspectRatio = Float(image.size.height) / Float(image.size.width)
        let newImageViewHeight = aspectRatio * Float(self.view.bounds.width)
        imageHeightConstraint.constant = CGFloat(newImageViewHeight)
        
        architectureNameLabel.text = arch.title
        architectureDescrLabel.text = arch.uid
    }
    
    func setLoading(state: LoadingState) {
        switch state {
        case .yetToBeLoaded:
            modelButton.setTitle("Load Model", for: .normal)
        case .loading(let progress):
            modelButton.isUserInteractionEnabled = false
            modelButton.setTitle("\(Int(progress * 100))%", for: .normal)
        case .done:
            modelButton.setTitle("Show 3D", for: .normal)
            modelButton.isUserInteractionEnabled = true
        }
    }
    
    
}
