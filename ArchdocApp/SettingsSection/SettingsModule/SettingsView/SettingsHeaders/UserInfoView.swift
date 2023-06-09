//
//  UserInfoView.swift
//  ArchdocApp
//
//  Created by tixomark on 2/14/23.
//

import UIKit

class UserInfoView: UIView {
    
    var userImageView: UIImageView!
    var userNickName: UILabel!
    var infoLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .archDocSystemColor
        createUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        userImageView = UIImageView()
        self.addSubview(userImageView)
        userImageView.backgroundColor = .archDocSecondarySystemColor
        
        userNickName = UILabel()
        self.addSubview(userNickName)
        userNickName.backgroundColor = .clear
        userNickName.textAlignment = .center
        userNickName.text = ""
        
        infoLabel = UILabel()
        self.addSubview(infoLabel)
        infoLabel.backgroundColor = .clear
        infoLabel.textAlignment = .center
        infoLabel.text = ""
    }
    
    private func setUpConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNickName.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let infoLabelBottomAnchor = infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        infoLabelBottomAnchor.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.topAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: self.frame.width / 4),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor),
            userImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            userNickName.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userNickName.widthAnchor.constraint(equalToConstant: self.frame.width - 30),
            userNickName.heightAnchor.constraint(equalToConstant: 64),
            userNickName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: userNickName.bottomAnchor),
            infoLabel.widthAnchor.constraint(equalToConstant: self.frame.width - 30),
            infoLabel.heightAnchor.constraint(equalToConstant: 44),
            infoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            infoLabelBottomAnchor])
    }
    
    func configureUsing(_ user: User) {
//        userImageView.image = user.pofileImage
        userNickName.text = user.firstName + "  " + user.lastName
        infoLabel.text = user.email
    }
}
