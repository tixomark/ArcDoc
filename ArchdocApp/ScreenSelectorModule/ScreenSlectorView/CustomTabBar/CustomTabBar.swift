//
//  CustomTabBar.swift
//  ArchdocApp
//
//  Created by tixomark on 1/23/23.
//

import UIKit

protocol CustomTabBarDataSource: AnyObject {
    func tabBar(numberOfElementsIn tabBar: CustomTabBar) -> Int
    func tabBar(_ tabBar: CustomTabBar, elementFoRowAt index: Int) -> UIView
}

protocol CustomTabBarDelegate: AnyObject {
    func tabBar(_ tabBar: CustomTabBar, didSelectElementAt index: Int)
}

class CustomTabBar: UIView {
    
    weak var dataSource: CustomTabBarDataSource?
    weak var delegate: CustomTabBarDelegate?
    
    private var itemViews = [UIView]()
    
    var itemsPadding: CGFloat = 0
    var edgeOffset: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpGestures()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpGestures()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadTabBar()
    }
    
    func reloadTabBar() {
        guard let dataSource = dataSource else {return}
        
        let frame = self.bounds
        let numberOfElements = dataSource.tabBar(numberOfElementsIn: self)
        let itemHeight = frame.height - edgeOffset * 2
        let itemWidth = (frame.width - edgeOffset * 2 - itemsPadding * CGFloat(numberOfElements - 1)) / CGFloat(numberOfElements)
        
        var xPosition = edgeOffset
        
        itemViews = (0..<numberOfElements).map({ index in
            let view = dataSource.tabBar(self, elementFoRowAt: index)
            view.frame = CGRect(x: xPosition, y: edgeOffset, width: itemWidth, height: itemHeight)
            self.addSubview(view)
            xPosition += (itemsPadding + itemWidth)
            
            return view
        })
    }
    
    private func setUpGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture: )))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap(gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: self)
        if let index = itemViews.firstIndex(where: { $0.frame.contains(tapPoint) }) {
            delegate?.tabBar(self, didSelectElementAt: index)
        }
    }

}

