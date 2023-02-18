//
//  UIColor+Extension.swift
//  ArchdocApp
//
//  Created by tixomark on 2/18/23.
//

import Foundation
import UIKit

extension UIColor {
    static var archDocSystemColor: UIColor {
        guard let color = UIColor(named: "systemColor") else {
            print("Can not find 'systemColor' in assets folder")
            return UIColor()
        }
        return color
    }
    
    static var archDocSecondarySystemColor: UIColor {
        guard let color = UIColor(named: "systemSecondaryColor") else {
            print("Can not find 'systemSecondaryColor' in assets folder")
            return UIColor()
        }
        return color
    }
    
    static var archDocTernarySystemColor: UIColor {
        guard let color = UIColor(named: "systemTernaryColor") else {
            print("Can not find 'systemTernaryColor' in assets folder")
            return UIColor()
        }
        return color
    }
}
