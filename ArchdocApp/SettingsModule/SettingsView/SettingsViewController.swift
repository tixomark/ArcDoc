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
    var editBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    let options: [String] = ["About us"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "genericCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        setUpUI()
        presenter.requestHeaderUpdate()
    }
    
    deinit {
        print("deinit 'SettingsViewController'")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.requestHeaderUpdate()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.adjustHeaderViewToFit()
    }
    
    private func setUpUI() {
        editBarButtonItem = UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(editAction(_:)))
    }
    
    @objc func editAction(_ sender: UIBarButtonItem) {
        presenter.didTapOnEditButton()
        print("want to edit")
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genericCell", for: indexPath)
        
        cell.textLabel?.text = options[indexPath.row]
        
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
    func changeHeaderAccordingTo(_ state: UserAuthState) {
        switch state {
        case .userSignedIn:
            userView = UserInfoView()
            tableView.tableHeaderView = userView
            self.navigationItem.rightBarButtonItem = editBarButtonItem
        case .noUser:
            logInButtonView = LogInButtonView()
            logInButtonView.delegate = self
            tableView.tableHeaderView = logInButtonView
            self.navigationItem.rightBarButtonItem = nil
        }
    }
}
