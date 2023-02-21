//
//  AuthTextFieldView.swift
//  ArchdocApp
//
//  Created by tixomark on 2/17/23.
//

import UIKit


protocol AuthTextFieldViewDelegate: AnyObject {
    func didEndEditingTextFieldOf(_ containerView: AuthTextFieldView)
    func valueChangedInTextFieldOf(_ containerView: AuthTextFieldView)
    func textFieldShouldReturnOf(_ containerView: AuthTextFieldView)
}
extension AuthTextFieldViewDelegate {
    func didEndEditingTextFieldOf(_ containerView: AuthTextFieldView) {}
    func valueChangedInTextFieldOf(_ containerView: AuthTextFieldView) {}
    func textFieldShouldReturnOf(_ containerView: AuthTextFieldView) {}
}

class AuthTextFieldView: UIView {
    
    var textField: UITextField!
    var bottomLabel: UILabel!
    
    weak var delegate: AuthTextFieldViewDelegate!
    
    init(placeholder: String, returnKeyType: UIReturnKeyType, keyboardType: UIKeyboardType) {
        super.init(frame: .zero)
        backgroundColor = .clear
        createUI()
        addActions()
        
        textField.delegate = self
        textField.placeholder = placeholder
        textField.returnKeyType = returnKeyType
        textField.keyboardType = keyboardType
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraints()
    }

    private func createUI() {
        textField = UITextField()
        self.addSubview(textField)
        self.backgroundColor = .archDocSecondarySystemColor
        self.layer.cornerRadius = 10
        
        textField.placeholder = ""
        textField.returnKeyType = .next
        
        bottomLabel = UILabel()
        self.addSubview(bottomLabel)
        bottomLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)
    }
    
    private func setUpConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textField.heightAnchor.constraint(equalToConstant: 44)])
        
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLabel.topAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            bottomLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLabel.heightAnchor.constraint(equalToConstant: 22)])
    }
    
    func addActions() {
        textField.addTarget(self, action: #selector(textFieldChangedAction(_:)), for: .editingChanged)
    }
    
    @objc func textFieldChangedAction(_ sender: UITextField) {
        delegate.valueChangedInTextFieldOf(self)
    }
}

extension AuthTextFieldView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        delegate.didEndEditingTextFieldOf(self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate.textFieldShouldReturnOf(self)
        return true
    }
}
