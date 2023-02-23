//
//  EmailVerificationViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 2/23/23.
//

import UIKit

class EmailVerificationViewController: UIViewController {
    var presenter: EmailVerificationPresenterProtocol!
    
    var verificationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .archDocSystemColor
        navigationItem.setHidesBackButton(true, animated: true)
        setUpUI()
        
        presenter.viewLoaded()
    }
    
    deinit {
        print("deinit 'EmailVerificationViewController'")
    }
    
    private func setUpUI() {
        verificationLabel = UILabel()
        view.addSubview(verificationLabel)
        
        verificationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verificationLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            verificationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            verificationLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width - 60)])
        
        verificationLabel.numberOfLines = 0
        verificationLabel.text = "To verify your email address please follow the link in letter we sent to the given email"
        verificationLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 20)
    }
}

extension EmailVerificationViewController: EmailVerificationViewProtocol {
    func updateLabelInfo(userEmail: String?) {
        guard userEmail != nil else { return }
        verificationLabel.text = "To verify your email address please follow the link in the letter we sent to " + userEmail!
    }
}
