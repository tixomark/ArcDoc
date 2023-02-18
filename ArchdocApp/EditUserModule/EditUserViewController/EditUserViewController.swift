//
//  EditUserViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/15/23.
//

import UIKit

class EditUserViewController: UIViewController {
    
    enum CellType: Int {
        case textCell, labelCell, painCell
    }
    
    var presenter: EditUserPresenterProtocol!
    
    var tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    var headerVeiw: HeaderView = HeaderView()
    var doneBarButton: UIBarButtonItem!
    var cancelBarButton: UIBarButtonItem!
    
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
        
        doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneAction(_:)))
        cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction(_:)))
        self.navigationItem.rightBarButtonItem = doneBarButton
        self.navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    @objc func doneAction(_ sender: UITabBarItem) {
        print("did tap")
    }
    @objc func cancelAction(_ sender: UITabBarItem) {
        print("did cancel")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
}

extension EditUserViewController: EditUserViewProtocol {
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
        return section == 0 ? 10 : 20
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
        
        let data = rowsTitles[indexPath.section]
        var cellType: CellType!
        switch indexPath.section {
        case 0, 1:
            cellType = .textCell
        case 2:
            cellType = .labelCell
        case 3:
            cellType = .painCell
        default:
            print("Can not match cellType")
        }
        
        let cell = createCell(ofType: cellType, usingData: data[indexPath.row])
        return cell
    }
    
    private func createCell(ofType type: CellType, usingData data: String) -> UITableViewCell {
        switch type {
        case .textCell:
            let cell = UserProfileTextCell()
            cell.delegate = self
            cell.configure(text: "", placeholder: data)
            cell.selectionStyle = .none
            return cell
        case .labelCell:
            let cell = UserProfileLabelCell()
            cell.configure(text: data, detailText: "some detail")
            return cell
        case .painCell:
            let cell = UserProfilePainCell()
            cell.configure(text: data, color: .red)
            return cell
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
        print(textField.text)
    }
    
}

