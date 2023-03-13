//
//  HeaderView.swift
//  ArchdocApp
//
//  Created by tixomark on 2/15/23.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func didTapOnChangeImageButton()
}

class HeaderView: UIView {
    var userImageView: UIImageView!
    var changeImageButton: UIButton!
    
    weak var delegate: HeaderViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .archDocSystemColor
        createUI()
        addActions()
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
        
        changeImageButton = UIButton()
        self.addSubview(changeImageButton)
        changeImageButton.backgroundColor = .archDocSecondarySystemColor
        changeImageButton.setTitle("Choose new avatar", for: .normal)
    }

    private func addActions() {
        changeImageButton.addTarget(self, action: #selector(changeImageAction(_:)), for: .touchUpInside)
    }
    
    @objc private func changeImageAction(_ sender: UIButton) {
        delegate.didTapOnChangeImageButton()
    }

    func setUpConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        changeImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        let userImageViewBottomAnchor = changeImageButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        userImageViewBottomAnchor.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: self.topAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: self.frame.width / 4),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor),
            userImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            changeImageButton.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            changeImageButton.widthAnchor.constraint(equalToConstant: self.frame.width - 30),
            changeImageButton.heightAnchor.constraint(equalToConstant: 44),
            changeImageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            userImageViewBottomAnchor])
    }
}
