//
//  ScrollableScopeSelector.swift
//  ArchdocApp
//
//  Created by tixomark on 3/4/23.
//

import Foundation
import UIKit

protocol ScrollableScopeViewDataSource: AnyObject {
    func numberOfItems(in scrollableScopeView: ScrollableScopeView) -> Int
    func scrollableScopeView(_ scrollableScopeView: ScrollableScopeView, labelForItemAt index: Int) -> String
}

protocol ScrollableScopeViewDelegate: AnyObject {
        func scrollableScopeView(_ scrollableScopeView: ScrollableScopeView, didSelectItemAt index: Int)
}

class ScrollableScopeView: UIScrollView {
    private var labels: [UILabel] = []
    private var dafaultLabelSize: CGSize = CGSize(width: 100, height: 50)
    private var customIntrinsicContentSize: CGSize = CGSize()
    override internal var intrinsicContentSize: CGSize {
        return customIntrinsicContentSize
    }
    
    var itemsSpaceing: CGFloat = 0
    
    weak var customDataSource: ScrollableScopeViewDataSource?
    weak var customDelegate: ScrollableScopeViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    func reloadData() {
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll()
        var contentSize = CGSize()
        
        if let numberOfItems = customDataSource?.numberOfItems(in: self) {
            for index in 0..<numberOfItems {
                let label = UILabel()
                label.text = customDataSource?.scrollableScopeView(self, labelForItemAt: index)
                label.textAlignment = .center
                label.backgroundColor = .systemGray
                addSubview(label)
                labels.append(label)
            }
            
            labels.forEach { label in
                let labelWidth = label.text?.widthOfString(usingFont: label.font)
                let labelHeight = label.text?.heightOfString(usingFont: labels[0].font)
                label.frame.size.width = (labelWidth ?? dafaultLabelSize.width) + 10
                label.frame.size.height = (labelHeight ?? dafaultLabelSize.height) + 10
                
                if labels.firstIndex(of: label) == 0 {
                    label.frame.origin.x = contentSize.width
                    contentSize.width += label.frame.size.width
                } else {
                    label.frame.origin.x = contentSize.width + itemsSpaceing
                    contentSize.width += label.frame.size.width + itemsSpaceing
                }
                contentSize.height = max(contentSize.height, label.frame.size.height)
            }
            customIntrinsicContentSize.height = labels[0].frame.height + contentInset.top + contentInset.bottom
        }
        self.contentSize = contentSize
        setContentOffset(CGPoint(x: -contentInset.left, y: -contentInset.top), animated: true)
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func selectItem(atIndex index: Int) {
        let selectedLabel = labels[index]
        let maxContentOffset = contentSize.width + contentInset.left - self.frame.width
        let xOffset = selectedLabel.frame.origin.x - contentInset.left
        let newOffset = min(maxContentOffset, xOffset)
        setContentOffset(CGPoint(x: newOffset, y: -contentInset.top), animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        for (index, label) in labels.enumerated() {
            if label.frame.contains(touchLocation) {
                selectItem(atIndex: index)
                customDelegate?.scrollableScopeView(self, didSelectItemAt: index)
                break
            }
        }
    }
    
}
