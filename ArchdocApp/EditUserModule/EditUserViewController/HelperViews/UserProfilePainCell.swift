//
//  UserProfilePainCell.swift
//  ArchdocApp
//
//  Created by tixomark on 2/16/23.
//

import UIKit

class UserProfilePainCell: UITableViewCell {
    
    var label: UILabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layOutCellContents()
    }
    
    private func layOutCellContents() {
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)])
        
        label.textAlignment = .center
    }
    
    func configure(text: String, color: UIColor) {
        label.text = text
        label.textColor = color
    }
    
    
}
