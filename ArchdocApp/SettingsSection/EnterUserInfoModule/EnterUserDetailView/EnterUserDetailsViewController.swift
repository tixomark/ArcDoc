//
//  EnterUserDetailViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/23/23.
//

import UIKit

class EnterUserDetailsViewController: UIViewController {
    var presenter: EnterUserDetailsPresenterProtocol!
    
    var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    var editableCells: [UITableViewCell: IndexPath] = [:]
    var doneButton: UIButton!
    
    let sectionFooters: [String] = ["Enter your name", "Any details about yourself"]
    let rowsTitles: [[String]] = [["First Name", "Last Name"], ["Bio"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)
        setUpUI()
        setUpActions()
        tableView.backgroundColor = .archDocSystemColor
        
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    deinit {
        print("deinit 'EnterUserDetailViewController'")
    }
    
    private func setUpUI() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
        
        tableView.backgroundColor = .systemGroupedBackground
        
        doneButton = UIButton()
        self.view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 200),
            doneButton.heightAnchor.constraint(equalToConstant: 60)])
        
        doneButton.setTitle("Finish", for: .normal)
        doneButton.backgroundColor = .systemOrange
        doneButton.layer.cornerRadius = 10
        setDoneButtonIsEnabled(to: false)
    }

    private func setUpActions() {
        doneButton.addTarget(self, action: #selector(doneButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc private func doneButtonAction(_ sender: UIButton) {
        presenter.userDidTapOnDone()
    }

}

extension EnterUserDetailsViewController: EnterUserDetailsViewProtocol {
    func setDoneButtonIsEnabled(to value: Bool) {
        doneButton.alpha = value ? 1 : 0.5
        doneButton.isEnabled = value
    }
}

extension EnterUserDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionFooters.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 20 : 20
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sectionFooters[section]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsTitles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellLabel = rowsTitles[indexPath.section][indexPath.row]
        let cell = UserProfileTextCell()
        cell.delegate = self
        cell.configure(text: "", placeholder: cellLabel)
        editableCells[cell] = indexPath
        cell.selectionStyle = .none
        return cell
    }
}

extension EnterUserDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EnterUserDetailsViewController: UserProfileTextCellDelegate {
    func textFieldValueChanged(_ textField: UITextField, inCell cell: UserProfileTextCell) {
        guard let cellIndexPath = editableCells[cell], let text = textField.text else { return }
        presenter.textFieldValueChanged(text, inCellAtIndexPath: cellIndexPath)
    }
    
}



