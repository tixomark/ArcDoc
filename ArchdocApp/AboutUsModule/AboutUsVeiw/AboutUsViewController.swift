//
//  AboutUsViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/23/23.
//

import UIKit

class AboutUsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  let sections = ["Section 1", "Section 2", "Section 3"]
  let sectionData = [["This is text for Row 1", "This is text for Row 2"], ["This is text for Row 1"], ["This is text for Row 1", "This is text for Row 2", "This is text for Row 3"]]
  var selectedSection = -1

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
  }
}

extension AboutUsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == selectedSection {
      return sectionData[section].count
    } else {
      return 0
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

    let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
    label.text = sectionData[indexPath.section][indexPath.row]
    cell.addSubview(label)

    return cell
  }
}

extension AboutUsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray

        let headerLabel = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerLabel.textColor = UIColor.black
        headerLabel.text = sections[section]
        headerView.addSubview(headerLabel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.headerTapped(_:)))
        headerView.addGestureRecognizer(tapGesture)

        return headerView
    }

    @objc func headerTapped(_ sender: UITapGestureRecognizer) {
        let index = sender.view?.tag
        if selectedSection == index {
            selectedSection = index!
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

