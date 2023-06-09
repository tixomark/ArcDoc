//
//  UIImageToDataTrasformer.swift
//  ArchdocApp
//
//  Created by tixomark on 2/6/23.
//

import Foundation
import UIKit

public final class UIImageToDataTrasformer: ValueTransformer {
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let images = value as? [UIImage] else { return nil }

        do {
            
            let data = try NSKeyedArchiver.archivedData(withRootObject: images, requiringSecureCoding: true)
            return data
        } catch {
            print("Failed to transform `[UIImage]` to `Data`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let imagesData = value as? Data else { return nil }
        
        do {
            
            let images = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: UIImage.self, from: imagesData)
            return images
        } catch {
            print("Failed to transform `Data` to `[UIImage]`")
            return nil
        }
    }
    
    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
}

extension UIImageToDataTrasformer {
    static let name = NSValueTransformerName(String(describing: UIImageToDataTrasformer.self))
    
    public static func register() {
        let transformer = UIImageToDataTrasformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
