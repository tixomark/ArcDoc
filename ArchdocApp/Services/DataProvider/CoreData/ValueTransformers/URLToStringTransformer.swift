//
//  URLToStringTransformer.swift
//  ArchdocApp
//
//  Created by tixomark on 2/6/23.
//

import Foundation

public final class URLToStringTransformer: ValueTransformer {
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let modelURL = value as? URL else { return nil }
        
        
        let modelName = NSString(string: modelURL.lastPathComponent)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: modelName, requiringSecureCoding: true)
            return data
            
        } catch {
            print("Failed to transform `URL` to `NSString`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }

        do {
            let modelName = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self,
                                                                   from: data)
            let modelsDirPath = FileManager.default.modelsDir
            
            guard let name = modelName as? String,
                    let absoluteURL = URL(string: name, relativeTo: modelsDirPath)
            else {
                print("Can not create URL named \(String(describing: modelName))")
                return nil
            }
            return absoluteURL
            
        } catch {
            print("Failed to transform `NSString` to `URL`")
            return nil
        }
    }
    
    override public class func allowsReverseTransformation() -> Bool {
        return true
    }
}

extension URLToStringTransformer {
    static let name = NSValueTransformerName(String(describing: URLToStringTransformer.self))
    
    public static func register() {
        let transformer = URLToStringTransformer()
        URLToStringTransformer.setValueTransformer(transformer, forName: name)
    }
    
}
