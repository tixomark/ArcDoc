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
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        mainImageView.contentMode = .scaleAspectFit
        
        presenter.setUIData()
    }
    deinit {
        print("deinit detailVC")
    }

    @IBAction func tap3DModelButton(_ sender: Any) {
        modelButton.setTitle("Loading", for: .normal)
        presenter.didTapOn3DViewButton()
    }

}

extension DetailViewController: DetailViewProtocol {
    
    func setUIData(architectureItem: Architecture?) {
        guard let arch = architectureItem else { return }
        
        let image: UIImage!
        do {
//            let imageURL = URL(string: (arch.previewImageFileNames?.first)!,
//                               relativeTo: presenter.dataProvider?.imagesFolder)
//            let imageData = try Data(contentsOf: imageURL!)
//            image = UIImage(data: imageData)
        } catch {
            image = UIImage(named: "noImage")
        }
//        mainImageView.image = image
//        
//        let aspectRatio = Float(image.size.height) / Float(image.size.width)
//        let newImageViewHeight = aspectRatio * Float(self.view.bounds.width)
//        imageHeightConstraint.constant = CGFloat(newImageViewHeight)
        
        architectureNameLabel.text = arch.uid
//        architectureDescrLabel.text = arch.previewImageFileNames?.first
    }
    
}
