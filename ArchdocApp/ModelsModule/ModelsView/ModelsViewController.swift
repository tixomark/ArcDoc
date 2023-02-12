//
//  MainTableViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import UIKit

class ModelsViewController: UIViewController {
    
    private struct Values {
        static let architectureCellID = "ArchCell"
        static let noImage = "noImage"
    }
    
    @IBOutlet weak var architectureCatalogueTable: UITableView!
    
    var presenter: ModelsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        self.title = "Models"
        
        architectureCatalogueTable.delegate = self
        architectureCatalogueTable.dataSource = self
        architectureCatalogueTable.register(ArchitectureTableCell.self,
                                            forCellReuseIdentifier: Values.architectureCellID)
        architectureCatalogueTable.separatorStyle = .none
    }
    
    deinit {
        print("deinit MainViewController")
    }
    
}

extension ModelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.architecture?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Values.architectureCellID, for: indexPath) as! ArchitectureTableCell
        
        cell.configure(architecture: presenter.architecture?[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var imageSize: CGSize = CGSize(width: 1, height: 1)
        if let size = presenter.architecture?[indexPath.row].previewImages?.first?.size {
            imageSize = size
        }

        let imageAspectRatio = Float(imageSize.height / imageSize.width)
        let inset: Float = 10
        let cellHeight = (Float(tableView.frame.width) - inset * 2) * imageAspectRatio + inset * 3 + 50

        return CGFloat(cellHeight)
    }
    
    
}

extension ModelsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tappedOnCell(atIndexPath: indexPath)
    }
}

extension ModelsViewController: ModelsViewProtocol {
    func reloadTable() {
        architectureCatalogueTable.reloadData()
    }
}


