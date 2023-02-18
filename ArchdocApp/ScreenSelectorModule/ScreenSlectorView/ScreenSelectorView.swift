//
//  ScreenSelectorView.swift
//  ArchdocApp
//
//  Created by tixomark on 1/24/23.
//

import Foundation
import UIKit

class ScreenSelectorView: UIView {
    
    var presenter: ScreenSelectorPresenterProtocol!
    
    var tabBar = CustomTabBar()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ititialiseView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        ititialiseView()
    }
    
    deinit {
        print("deinit 'ScreenSelectorView'")
    }
    
    private func ititialiseView() {
        self.backgroundColor = .clear
        self.addSubview(tabBar)

        tabBar.backgroundColor = .archDocSecondarySystemColor//.withAlphaComponent(0.8)
        tabBar.dataSource = self
        tabBar.delegate = self
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tabBar.topAnchor.constraint(equalTo: self.topAnchor),
            tabBar.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
        
        tabBar.layer.cornerRadius = 20
        tabBar.edgeOffset = 10
        tabBar.itemsPadding = 40
    }
    
    
    
}

extension ScreenSelectorView: CustomTabBarDataSource {
    func tabBar(numberOfElementsIn tabBar: CustomTabBar) -> Int {
        return presenter.tabBarItems?.count ?? 0
    }
    
    func tabBar(_ tabBar: CustomTabBar, elementFoRowAt index: Int) -> UIView {
        var view = UIImageView()
        if let item = presenter.tabBarItems?[index] {
            let icon = UIImage(named: item.normalStateImageName)
            view = UIImageView(image: icon)
        }
        view.contentMode = .scaleAspectFit
        
        return view
    }
}

extension ScreenSelectorView: CustomTabBarDelegate {
    func tabBar(_ tabBar: CustomTabBar, didSelectElementAt index: Int) {
        presenter.tapOnItem(index: index)
    }
}

extension ScreenSelectorView: ScreenSelectorViewProtocol {

}
