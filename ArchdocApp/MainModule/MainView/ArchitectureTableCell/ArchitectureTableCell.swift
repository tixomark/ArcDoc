//
//  ArchitectureCatalogueCell.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import UIKit

class ArchitectureTableCell: UITableViewCell {
    
    var mainImageView: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        confugureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func confugureUI() {
        mainImageView = UIImageView()
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainImageView)
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            mainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)])
        
        mainImageView.layer.cornerRadius = 10
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        self.selectionStyle = .none
//        self.backgroundColor = .white
        
    }
    
    func configure(imageName: String) {
        mainImageView?.image = UIImage(named: imageName)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
