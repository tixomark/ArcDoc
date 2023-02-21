//
//  EditUserViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/15/23.
//

import UIKit

class EditUserViewController: UIViewController {
    var presenter: EditUserPresenterProtocol!
    
    var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    var headerVeiw: HeaderView = HeaderView()
    var doneBarButton: UIBarButtonItem!
    var cancelBarButton: UIBarButtonItem!
    
    var editableCells: [UITableViewCell: IndexPath] = [:]
    
    let sectionFooters: [String] = ["Enter your name",
                                    "Any details about yourself",
                                    "",
                                    ""]
    let rowsTitles: [[String]] = [["First Name", "Last Name"], ["Bio"], ["Email", "Username"], ["Log Out"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        headerVeiw.delegate = self
        presenter.configureViewAppearance()
    }
    
    deinit {
        print("deinit 'EditUserViewController'")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.adjustHeaderViewToFit()
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
        tableView.tableHeaderView = headerVeiw
        
        doneBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction(_:)))
        cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction(_:)))
        
        self.navigationItem.rightBarButtonItem = doneBarButton
        self.navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    @objc func doneAction(_ sender: UITabBarItem) {
        presenter.userDidTapOnDone()
    }
    @objc func cancelAction(_ sender: UITabBarItem) {
        presenter.userDidTapOnCancel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
}

extension EditUserViewController: EditUserViewProtocol {
    func setAppearanceUsingData(_ user: User) {
        tableView.reloadData()
    }
    
    func selfDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditUserViewController: UITableViewDataSource {
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
        var data: String = ""
        if let cellData = presenter.getDataForCell(atIndexPath: indexPath) {
            data = cellData
        }
        
        let cell = createCell(forPosition: indexPath, usingData: data)
        return cell
    }
    
    private func createCell(forPosition indexPath: IndexPath, usingData data: String) -> UITableViewCell {
        let cellLabel = rowsTitles[indexPath.section][indexPath.row]
        switch indexPath.section {
        case 0, 1:
            let cell = UserProfileTextCell()
            cell.delegate = self
            cell.configure(text: data, placeholder: cellLabel)
            editableCells[cell] = indexPath
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = UserProfileLabelCell()
            cell.configure(title: cellLabel, infoText: data)
            return cell
        case 3:
            let cell = UserProfilePainCell()
            cell.configure(title: cellLabel, color: .red)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension EditUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.userDidTapOnRow(atIndexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EditUserViewController: HeaderViewDelegate {
    func didTapOnChangeImageButton() {
        presenter.userDidTapOnChangeImageButton()
    }
}

extension EditUserViewController: UserProfileTextCellDelegate {
    func textFieldValueChanged(_ textField: UITextField, inCell cell: UserProfileTextCell) {
        guard let cellIndexPath = editableCells[cell], let text = textField.text else { return }
        presenter.textFieldValueChanged(text, inCellAtIndexPath: cellIndexPath)
    }
    
}

