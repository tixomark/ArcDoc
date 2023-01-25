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
        print(contentView.frame.width)
        mainImageView = UIImageView()
        contentView.addSubview(mainImageView)
        
        let inset: CGFloat = 10
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: inset),
            mainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset)])
        
        mainImageView.backgroundColor = .green
        mainImageView.layer.cornerRadius = 20
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.clipsToBounds = true
        self.selectionStyle = .none
        
    }
    
    func configure(imageName: String) {
        mainImageView?.image = UIImage(named: imageName)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
