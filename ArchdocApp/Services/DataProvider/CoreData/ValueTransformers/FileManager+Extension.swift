//
//  FileManager+Extension.swift
//  ArchdocApp
//
//  Created by tixomark on 2/6/23.
//

import Foundation

extension FileManager {
    var modelsDir: URL {
        let userDomain = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let modelsDir = FileManager.default.createDir(named: "models", in: userDomain)
        
        return modelsDir
    }
    
    private func createDir(named dirName: String, in rootDir: URL) -> URL {
        var dirURL: URL!
        
        if let newDirURL = URL(string: rootDir.absoluteString + dirName + "/") {
            
            if FileManager.default.directoryExists(atUrl: newDirURL) {
                print("Directory named \(dirName) already exists")
                dirURL = newDirURL
                
            } else {
                do {
                    try FileManager.default.createDirectory(at: newDirURL, withIntermediateDirectories: true)
                    print("Successfully created \(dirName)")
                    dirURL = newDirURL
                } catch {
                    print("An error occured while creating \(dirName)")
                }
            }
            
        } else {
            dirURL = rootDir
            print("Can not create directory \(dirName)")
        }
        
        return dirURL
    }
    
    private func directoryExists(atUrl url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = self.fileExists(atPath: url.path, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}
