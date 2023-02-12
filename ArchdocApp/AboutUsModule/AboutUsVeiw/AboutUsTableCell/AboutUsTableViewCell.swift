//
//  AboutUsTableViewCell.swift
//  ArchdocApp
//
//  Created by tixomark on 2/10/23.
//

import UIKit

class AboutUsTableViewCell: UITableViewCell {

    var titleLabel: UILabel!
    var cellBodyView: UIView!
    var textView: UILabel!
    private var cellBodyViewHeight: NSLayoutConstraint!
    var isInitiallyCollapsed = true
    
    static let cellID = "AboutUsTableViewCellID"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setUpUI() {
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.backgroundColor = .systemGreen
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 44)])
        
        cellBodyView = UIView()
        contentView.addSubview(cellBodyView)
        cellBodyView.backgroundColor = .magenta
        cellBodyView.translatesAutoresizingMaskIntoConstraints = false
        let bottomAnchor = cellBodyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottomAnchor.priority = UILayoutPriority(rawValue: 999)
        NSLayoutConstraint.activate([
            cellBodyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            cellBodyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBodyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomAnchor])
        cellBodyViewHeight = cellBodyView.heightAnchor.constraint(equalToConstant: 0)
        
        textView = UILabel(frame: cellBodyView.frame)
        cellBodyView.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: cellBodyView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: cellBodyView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: cellBodyView.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: cellBodyView.bottomAnchor)])
        textView.backgroundColor = .blue
        textView.numberOfLines = 0
        textView.text = "sdlsadkf asdf ansdjgfn asjkdn faijsdn fiasndmf iajsdnjasd jkasnd kajnsdkj nfkajsd nfkajsdngkjasnak sjasdfasd fas fasdf nasdfj kasndjfjak dnafl sjfn asldkjfnas nasd"
    }
    
    func setUpCell(usingData data: String, isCollapsed: Bool) {
        titleLabel.text = data
        cellBodyViewHeight.isActive = isCollapsed
    }
    
    func expand() {
        cellBodyViewHeight.isActive = false
    }
    
    func collapse() {
        cellBodyViewHeight.isActive = true
    }
}


