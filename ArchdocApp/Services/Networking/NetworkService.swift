//
//  NetworkService.swift
//  ArchdocApp
//
//  Created by tixomark on 2/2/23.
//

import Foundation

protocol NetworkServiceProtocol {
    
}

class NetworkService {
    
    let serviceURLSession = URLSession(configuration: .default)
    
    func loadData(at atUrl: URL, completion: @escaping (URL) -> ()) {
        let downloadTask = serviceURLSession.downloadTask(with: atUrl) { url, response, error in
            if let url = url {
                print("Data downloaded to \(url)")
                completion(url)
            } else if let error = error {
                print(error.localizedDescription)
                print("Can not load data at \(atUrl)")
            }
        }
        downloadTask.resume()
        
    }
    
//    func load3DModel(at atUrl: URL, complation: @escaping)
}
