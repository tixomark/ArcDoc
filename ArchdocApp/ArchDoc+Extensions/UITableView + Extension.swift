//
//  UITableView + Extension.swift
//  ArchdocApp
//
//  Created by tixomark on 2/17/23.
//

import Foundation
import UIKit

extension UITableView {
    func adjustHeaderViewToFit() {
        guard let headerView = self.tableHeaderView else { return }
        
        let height = headerView.systemLayoutSizeFitting(CGSize(width: self.frame.width, height: .greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow).height
        
        if height != headerView.frame.size.height {
            headerView.frame.size.height = height
            self.tableHeaderView = headerView
        }
    }
    
}
