//
//  ArchitectureCatalogueCell.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import UIKit

class ArchitectureTableCell: UITableViewCell {
    
    var mainImageView: UIImageView!
    var architectureNameLabel: UILabel!
    
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
        contentView.addSubview(mainImageView)
        architectureNameLabel = UILabel()
        contentView.addSubview(architectureNameLabel)
        
        let inset: CGFloat = 10
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        architectureNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: inset),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset)])
        
        NSLayoutConstraint.activate([
            architectureNameLabel.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: inset),
            architectureNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            architectureNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            architectureNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset)])
        architectureNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        architectureNameLabel.backgroundColor = .magenta
        
        mainImageView.backgroundColor = .green
        mainImageView.layer.cornerRadius = 20
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.clipsToBounds = true
        self.selectionStyle = .none
        
    }
    
    func configure(architecture: Architecture?, imageDir: URL) {
        guard let arch = architecture else { return }

//        if let imageUrl = URL(string: (arch.previewImageFileNames?.first)!,
//                              relativeTo: imageDir),
//            let imageData = try? Data(contentsOf: imageUrl) {
//            mainImageView?.image = UIImage(data: imageData)
//        }
//        else {
//            mainImageView?.image = UIImage(named: "noImage")
//        }

        architectureNameLabel.text = (arch.title ?? "") + " " + (arch.uid ?? "")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
