//
//  SettingsViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/12/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var presenter: SettingsPresenterProtocol!
    var userView: UserInfoView!
    var logInButtonView: LogInButtonView!
    var headerViewState: UserAuthState!
    var editBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    let sectionData: [[String]] = [["Comments", "Messages"], ["Notifications", "Data and Storage", "Appearance"], ["FAQ"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        tableView.backgroundColor = .archDocSystemColor
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "genericCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        userView = UserInfoView()
        logInButtonView = LogInButtonView()
        
        setUpUI()
        presenter.viewLoaded()
    }
    
    deinit {
        print("deinit 'SettingsViewController'")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.adjustHeaderViewToFit()
    }
    
    private func setUpUI() {
        editBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editAction(_:)))
    }
    
    @objc func editAction(_ sender: UIBarButtonItem) {
        presenter.didTapOnEditButton()
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 20 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath)
        
        cell.textLabel?.text = sectionData[indexPath.section][indexPath.row]
        
        return cell
    }
}
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapOnCell(atIndex: indexPath)
    }
}

extension SettingsViewController: LogInButtonViewDelegate {
    func didTapOnLogInButton() {
        presenter.didTapOnLoginButton()
    }
}

extension SettingsViewController: SettingsViewProtocol {
    func updateHeaderDataUsing(userData data: User) {
        self.userView.configureUsing(data)
    }
    
    func changeHeaderConfigurationAccordingTo(_ state: UserAuthState) {
        guard state != headerViewState else { return }
        switch state {
        case .userSignedIn:
            logInButtonView.delegate = nil
            tableView.tableHeaderView = userView
            self.navigationItem.rightBarButtonItem = editBarButtonItem
        case .noUser:
            self.navigationItem.rightBarButtonItem = nil
            tableView.tableHeaderView = logInButtonView
            logInButtonView.delegate = self
        }
    }
}
