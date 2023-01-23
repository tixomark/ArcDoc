//
//  MainTableViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import UIKit

class MainViewController: UIViewController {

    private struct Values {
        static let architectureCellID = "ArchCell"
        static let noImage = "noImage"
    }
    
    @IBOutlet weak var architectureCatalogueTable: UITableView!
    
    var presenter: MainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        architectureCatalogueTable.delegate = self
        architectureCatalogueTable.dataSource = self
        architectureCatalogueTable.register(ArchitectureTableCell.self,
                                            forCellReuseIdentifier: Values.architectureCellID)
        architectureCatalogueTable.separatorStyle = .none
        // Do any additional setup after loading the view.
    }


}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.architecture?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Values.architectureCellID, for: indexPath) as! ArchitectureTableCell
        
        cell.configure(imageName: presenter.architecture?[indexPath.row].imageName ?? Values.noImage)
        
        print("createdCell\(indexPath.row)")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let (width, height) = presenter.getArchitectureImageDimensions(index: indexPath.row)
        let imageAspectRatio = height / width
        let cellHeight = Float(tableView.bounds.width) * imageAspectRatio
        return CGFloat(cellHeight)
    }
    
    
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let architecture = presenter.architecture?[indexPath.row]
        presenter.tapOnCell(architecture: architecture)
    }
}

extension MainViewController: MainViewProtocol {
    func getDimensionsOfImage(name: String?) -> (Float, Float){
        let imageSize = UIImage(named: name ?? Values.noImage)?.size
        return (Float(imageSize?.width ?? 1),
                Float(imageSize?.height ?? 1))
    }
    

    
    
}
