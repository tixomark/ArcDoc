//
//  LogInButtonView.swift
//  ArchdocApp
//
//  Created by tixomark on 2/15/23.
//

import UIKit

protocol LogInButtonViewDelegate: AnyObject {
    func didTapOnLogInButton()
}

class LogInButtonView: UIView {

    var logInButton: UIButton!
    
    weak var delegate: LogInButtonViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        createUI()
        addActions()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraints()
    }
    
    private func createUI() {
        logInButton = UIButton()
        self.addSubview(logInButton)
        logInButton.backgroundColor = .cyan
        logInButton.setTitle("Log in", for: .normal)
    }
    
    private func addActions() {
        logInButton.addTarget(self, action: #selector(logInAction(_:)), for: .touchUpInside)
    }
    
    @objc private func logInAction(_ sender: UIButton) {
        delegate.didTapOnLogInButton()
    }
    
    func setUpConstraints() {
        logInButton.translatesAutoresizingMaskIntoConstraints = false
       
        let logInButtonBottomAnchor = logInButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        logInButtonBottomAnchor.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(equalTo: self.topAnchor),
            logInButton.widthAnchor.constraint(equalToConstant: self.frame.width - 30),
            logInButton.heightAnchor.constraint(equalToConstant: 44),
            logInButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            logInButtonBottomAnchor])
        
    }
}

