//
//  UserProfileCell.swift
//  ArchdocApp
//
//  Created by tixomark on 2/16/23.
//

import UIKit

class UserProfileLabelCell: UITableViewCell {
    
    var label: UILabel = UILabel()
    var infoLabel: UILabel = UILabel()
    var accessoryIcon: UIImageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.backgroundColor = .archDocSecondarySystemColor
        layOutCellContents()
    }
    
    private func layOutCellContents() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
        label.textAlignment = .left
        
        self.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: self.topAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
        infoLabel.textAlignment = .right
        
        self.addSubview(accessoryIcon)
        accessoryIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            accessoryIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            accessoryIcon.leadingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            accessoryIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            accessoryIcon.heightAnchor.constraint(equalTo: self.heightAnchor),
            accessoryIcon.widthAnchor.constraint(equalTo: accessoryIcon.heightAnchor)])
    }
    
    func configure(title: String, infoText: String) {
        label.text = title
        infoLabel.text = infoText
    }
}
