//
//  LiteratureViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 3/4/23.
//

import UIKit

class LiteratureViewController: UIViewController {
    var presenter: LiteraturePresenterProtocol!

    var scope: ScrollableScopeView!
    var items: [String] = ["aaaaa", "bbb", "ccccccccccc", "nnnnnn", "kandsfkjansdkfjnsad", "bbb", "ccccccccccc", "nnnnnn", "kandsfkjansdkfjnsad", "bbb", "ccccccccccc", "nnnnnn", "kandsfkjansdkfjnsad"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .archDocSystemColor
        setupUI()
        setupLayout()
    }
    
    func setupUI() {
        scope = ScrollableScopeView()
        self.view.addSubview(scope)
        
        scope.itemsSpaceing = 10
        scope.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        scope.customDataSource = self
        scope.customDelegate = self
    }
    
    func setupLayout() {
        scope.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scope.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scope.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scope.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 110)])
        scope.reloadData()
    }

}

extension LiteratureViewController: LiteratureViewProtocol {
    func reloadTable() {
        
    }
}

extension LiteratureViewController: ScrollableScopeViewDataSource {
    func numberOfItems(in scrollableScopeView: ScrollableScopeView) -> Int {
        return items.count
    }
    
    func scrollableScopeView(_ scrollableScopeView: ScrollableScopeView, labelForItemAt index: Int) -> String {
        return items[index]
    }
}

extension LiteratureViewController: ScrollableScopeViewDelegate {
    func scrollableScopeView(_ scrollableScopeView: ScrollableScopeView, didSelectItemAt index: Int) {
        
    }
    
    
}
