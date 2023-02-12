//
//  SettingsViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/12/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var presenter: SettingsPresenterProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "genericCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath)
        
        cell.textLabel?.text = "About us"
        
        return cell
    }
    
    
}
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapOnCell(atIndex: indexPath)
        
    }
    
}
extension SettingsViewController: SettingsViewProtocol {
    
}
