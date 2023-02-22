//
//  EditUserDataViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/21/23.
//

import UIKit

//class SetUserDataViewController: UIViewController {
//
//    var firstNameView: AuthTextFieldView!
//    var lastNameView: AuthTextFieldView!
//    var confirmPasswordView: AuthTextFieldView!
//    var authButton: UIButton!
//
//    let spaceing: CGFloat = 30
//
//    var presenter: AuthPresenterProtocol!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = UIColor.archDocSystemColor
//        setUpUI()
//        setUpLayout()
//        setUpActions()
//
//        emailView.delegate = self
//        passwordView.delegate = self
//        confirmPasswordView.delegate = self
//
//        switchToLogInUI()
//        updateAuthButtonAccordingToAuthAvalability(false)
//        setCanEditPasswordConfirmationField(false)
//
//        presenter.viewLoaded()
//
//    }
//
//    deinit {
//        print("deinit 'AuthViewController'")
//    }
//
//    private func setUpLayout() {
//        logInButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            logInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
//            logInButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
//            logInButton.heightAnchor.constraint(equalToConstant: 60)])
//
//        signUpButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            signUpButton.topAnchor.constraint(equalTo: logInButton.topAnchor),
//            signUpButton.leadingAnchor.constraint(equalTo: logInButton.trailingAnchor, constant: 40),
//            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
//            signUpButton.widthAnchor.constraint(equalTo: logInButton.widthAnchor),
//            signUpButton.heightAnchor.constraint(equalTo: logInButton.heightAnchor)])
//
//        emailView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            emailView.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: spaceing),
//            emailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            emailView.widthAnchor.constraint(equalToConstant: view.bounds.width - 60)])
//
//        passwordView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            passwordView.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: spaceing),
//            passwordView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            passwordView.widthAnchor.constraint(equalTo: emailView.widthAnchor)])
//
//        confirmPasswordView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            confirmPasswordView.topAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: spaceing),
//            confirmPasswordView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            confirmPasswordView.widthAnchor.constraint(equalTo: emailView.widthAnchor)])
//
//        authButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            authButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
//            authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            authButton.widthAnchor.constraint(equalToConstant: 200),
//            authButton.heightAnchor.constraint(equalToConstant: 60)])
//    }
//
//    private func setUpUI() {
//        logInButton = UIButton()
//        view.addSubview(logInButton)
//        logInButton.setTitle("Log In", for: .normal)
//        logInButton.backgroundColor = .systemOrange
//        logInButton.layer.cornerRadius = 10
//
//
//        signUpButton = UIButton()
//        view.addSubview(signUpButton)
//        signUpButton.setTitle("Sign Up", for: .normal)
//        signUpButton.backgroundColor = .systemPink
//        signUpButton.layer.cornerRadius = 10
//
//        authButton = UIButton()
//        view.addSubview(authButton)
//        authButton.setTitle("Continue", for: .normal)
//        authButton.backgroundColor = .systemMint
//        authButton.layer.cornerRadius = 10
//
//        emailView = AuthTextFieldView(placeholder: "Enter email", returnKeyType: .next, keyboardType: .emailAddress)
//        passwordView = AuthTextFieldView(placeholder: "Enter password", returnKeyType: .default, keyboardType: .default)
//        confirmPasswordView = AuthTextFieldView(placeholder: "Confirm password", returnKeyType: .done, keyboardType: .default)
//        view.addSubview(emailView)
//        view.addSubview(passwordView)
//        view.addSubview(confirmPasswordView)
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        view.endEditing(true)
//    }
//
//    private func setUpActions() {
//        logInButton.addTarget(self, action: #selector(didSelectAuthOption(_:)), for: .touchUpInside)
//        signUpButton.addTarget(self, action: #selector(didSelectAuthOption(_:)), for: .touchUpInside)
//        authButton.addTarget(self, action: #selector(authButtonAction(_:)), for: .touchUpInside)
//    }
//
//    @objc private func didSelectAuthOption(_ sender: UIButton) {
//        let authOption: AuthOption = (sender == logInButton) ? .logIn : .signUp
//        presenter.didTapOnAuthOptionButton(ofType: authOption)
//    }
//
//    @objc private func authButtonAction(_ sender: UIButton) {
//        presenter.didTapOnAuthenticationButton()
//    }
//    }
