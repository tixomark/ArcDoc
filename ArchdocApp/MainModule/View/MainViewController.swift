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
    
    var presenter: MainViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        architectureCatalogueTable.delegate = self
        architectureCatalogueTable.dataSource = self
        architectureCatalogueTable.register(ArchitectureTableCell.self,
                                            forCellReuseIdentifier: Values.architectureCellID)
        architectureCatalogueTable.separatorStyle = .none
        architectureCatalogueTable.allowsFocus = false
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
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 4
    }
    
    
}
extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: MainViewProtocol {
    
}
