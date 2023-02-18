//
//  UserProfileTextCell.swift
//  ArchdocApp
//
//  Created by tixomark on 2/16/23.
//

import UIKit

protocol UserProfileTextCellDelegate: AnyObject {
    func didEndEditing(_ textField: UITextField, inCell cell: UserProfileTextCell)
    func textFieldValueChanged(_ textField: UITextField, inCell cell: UserProfileTextCell)
}
extension UserProfileTextCellDelegate {
    func didEndEditing(_ textField: UITextField, inCell cell: UserProfileTextCell) {}
}

class UserProfileTextCell: UITableViewCell {
    
    var textField: UITextField = UITextField()
    
    weak var delegate: UserProfileTextCellDelegate!
    
    init() {
        super.init(style: .default, reuseIdentifier: "")
        textField.returnKeyType = .done
        textField.delegate = self
        addActions()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layOutCellContents()
    }

    private func layOutCellContents() {
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    func configure(text: String, placeholder: String) {
        textField.text = text
        textField.placeholder = placeholder
    }
    
    func addActions() {
        textField.addTarget(self, action: #selector(textFieldChangedAction(_:)), for: .editingChanged)
    }
    
    @objc func textFieldChangedAction(_ sender: UITextField) {
        delegate.textFieldValueChanged(sender, inCell: self)
    }

}

extension UserProfileTextCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate.didEndEditing(textField, inCell: self)
        print("end edition")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

