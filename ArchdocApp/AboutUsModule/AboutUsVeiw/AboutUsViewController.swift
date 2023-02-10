//
//  AboutUsViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/23/23.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var expandedCells: IndexSet = []
    
    let sectionData = ["This is text for Row 1", "This is text for Row 2", "This is text for Row 3"]
   var selectedSection = -1
    
    var presenter: AboutUsPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(AboutUsTableViewCell.self, forCellReuseIdentifier: AboutUsTableViewCell.cellID)

        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension AboutUsViewController: AboutUsViewProtocol {

}

extension AboutUsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return sectionData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: AboutUsTableViewCell.cellID, for: indexPath) as! AboutUsTableViewCell
      
      let cellData = sectionData[indexPath.row]
      let isCollapsed = !expandedCells.contains(indexPath.row)
      cell.setUpCell(usingData: cellData, isCollapsed: isCollapsed)
      
    return cell
  }
}

extension AboutUsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AboutUsTableViewCell
        
        if expandedCells.contains(indexPath.row) {
            cell.collapse()
            expandedCells.remove(indexPath.row)
        } else {
            cell.expand()
            expandedCells.insert(indexPath.row)
        }

        tableView.beginUpdates()
        tableView.endUpdates()
        
    }

}

