//
//  AuthViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/13/23.
//

import UIKit

class AuthViewController: UIViewController {
    
    var logInButton: UIButton!
    var signInButton: UIButton!
    var emailView: AuthTextFieldView!
    var passwordView: AuthTextFieldView!
    var confirmPasswordView: AuthTextFieldView!
    var authButton: UIButton!
    
    var presenter: AuthPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.archDocSystemColor
        setUpUI()
        setUpLayout()
        setUpActions()
        
        emailView.delegate = self
        passwordView.delegate = self
        confirmPasswordView.delegate = self
        
        switchToSignInUI()
        updateAuthButtonAccordingToAuthAvalability(false)
        setCanEditPasswordConfirmationField(false)
    }
    
    deinit {
        print("deinit 'AuthViewController'")
    }
    
    private func setUpLayout() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            signInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            signInButton.widthAnchor.constraint(equalToConstant: 100),
            signInButton.heightAnchor.constraint(equalToConstant: 50)])
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            logInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            logInButton.widthAnchor.constraint(equalToConstant: 100),
            logInButton.heightAnchor.constraint(equalToConstant: 50)])
        
        emailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            emailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailView.widthAnchor.constraint(equalToConstant: view.bounds.width - 100)])
        
        passwordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordView.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 20),
            passwordView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordView.widthAnchor.constraint(equalTo: emailView.widthAnchor)])
        
        confirmPasswordView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmPasswordView.topAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: 20),
            confirmPasswordView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordView.widthAnchor.constraint(equalTo: emailView.widthAnchor)])
        
        authButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authButton.widthAnchor.constraint(equalToConstant: 300),
            authButton.heightAnchor.constraint(equalToConstant: 80)])
    }
    
    private func setUpUI() {
        logInButton = UIButton()
        view.addSubview(logInButton)
        logInButton.setTitle("Log In", for: .normal)
        logInButton.backgroundColor = .orange
        
        signInButton = UIButton()
        view.addSubview(signInButton)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.backgroundColor = .systemPink
        
        authButton = UIButton()
        view.addSubview(authButton)
        authButton.setTitle("Authorise", for: .normal)
        authButton.backgroundColor = .systemMint
        
        emailView = AuthTextFieldView(placeholder: "Enter email", returnKeyType: .next, keyboardType: .emailAddress)
        passwordView = AuthTextFieldView(placeholder: "Enter password", returnKeyType: .default, keyboardType: .default)
        confirmPasswordView = AuthTextFieldView(placeholder: "Confirm password", returnKeyType: .done, keyboardType: .default)
        view.addSubview(emailView)
        view.addSubview(passwordView)
        view.addSubview(confirmPasswordView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    private func setUpActions() {
        logInButton.addTarget(self, action: #selector(didSelectAuthOption(_:)), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(didSelectAuthOption(_:)), for: .touchUpInside)
        authButton.addTarget(self, action: #selector(authButtonAction(_:)), for: .touchUpInside)
    }
    
    @objc private func didSelectAuthOption(_ sender: UIButton) {
        let authOption: AuthOption = (sender == logInButton) ? .logIn : .signIn
        presenter.didTapOnAuthOptionButton(ofType: authOption)
    }
    
    @objc private func authButtonAction(_ sender: UIButton) {
        presenter.didTapOnAuthenticationButton()
    }
    
    private func switchToLogInUI() {
        signInButton.alpha = 0.4
        logInButton.alpha = 1
        confirmPasswordView.isHidden = false
        passwordView.textField.returnKeyType = .next
    }
    private func switchToSignInUI() {
        logInButton.alpha = 0.4
        signInButton.alpha = 1
        
        confirmPasswordView.isHidden = true
        confirmPasswordView.textField.text = ""
        confirmPasswordView.resignFirstResponder()
        passwordView.textField.returnKeyType = .done
    }
    
}

// MARK: - Conforming to AuthViewProtocol

extension AuthViewController: AuthViewProtocol {
    func updateUIToMatchAuth(option: AuthOption) {
        switch option {
        case .logIn:
            switchToLogInUI()
        case .signIn:
            switchToSignInUI()
        }
    }
    
    func updateAuthButtonAccordingToAuthAvalability(_ option: Bool) {
        authButton.isEnabled = option
        authButton.alpha = option ? 1 : 0.4
    }
    
    func setCanEditPasswordConfirmationField(_ canEdit: Bool) {
        confirmPasswordView.textField.isEnabled = canEdit
        confirmPasswordView.alpha = canEdit ? 1 : 0.4
        confirmPasswordView.bottomLabel.isHidden = !canEdit
    }
    
    func selfDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Conforming to AuthTextFieldViewDelegate

extension AuthViewController: AuthTextFieldViewDelegate {
    func didEndEditingTextFieldOf(_ containerView: AuthTextFieldView) {
        presenter.userDidFinishEditingTextField()
    }
    
    func valueChangedInTextFieldOf(_ containerView: AuthTextFieldView) {
        guard let text = containerView.textField.text else { return }
        var labelText: Validation = .none
        
        switch containerView {
        case emailView:
            presenter.userIsEditingEmail(text) { isValid in
                if !isValid {
                    labelText = .emailFailure
                }
            }
        case passwordView:
            presenter.userIsEditingPassword(text) { isValid in
                if !isValid {
                    labelText = .passwordHint
                }
                guard presenter.revalidateConfPassword() else {
                    confirmPasswordView.bottomLabel.text = Validation.passwordsDontMatch.rawValue
                    return
                }
                confirmPasswordView.bottomLabel.text = Validation.none.rawValue
            }
        case confirmPasswordView:
            presenter.userIsEditingConfirmationPassword(text) { isValid in
                if !isValid {
                    labelText = .passwordsDontMatch
                }
            }
        default:
            print("TextField value changed of '\(containerView.description)'")
        }
        containerView.bottomLabel.text = labelText.rawValue
    }
    
    func textFieldShouldReturnOf(_ containerView: AuthTextFieldView) {
        switch containerView {
        case emailView:
            passwordView.textField.becomeFirstResponder()
        case passwordView:
            if confirmPasswordView.isHidden {
                containerView.textField.resignFirstResponder()
            } else {
                confirmPasswordView.textField.becomeFirstResponder()
            }
        case confirmPasswordView:
            confirmPasswordView.textField.resignFirstResponder()
        default:
            print("Somehow there is more than three textFields on 'AuthViewController'")
        }
    }
}

