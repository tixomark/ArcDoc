//
//  SketchfabAPI.swift
//  ArchdocApp
//
//  Created by tixomark on 1/31/23.
//

import Foundation

extension String {
    func toBase64() -> String? {
        return (self.data(using: .utf8)?.base64EncodedString())
    }
    
    func fromBase64() -> String?  {
        return String(data: Data(base64Encoded: self)!, encoding: .utf8)
    }
}

class SketchfabAPI {
    
    private let clientID = "3w6ql5k6rUsj7tu3XvMgtzx89Mr0L4b7hBFxumvD"
    private let clientSecret = "aBt6S4TMDJgqlQ24cWKVoYiAiZ50dxTaYS3F3O5DRz9Dq0EOmDiz0qgFfn2n2f11Ppbfx2QwX4UCSgHdZ2hIWomNNRyq9k8VM6JbkRi6vc5FBStTvhLHYOuY3rGUs5lv"
    private let redirectUri = "https://archdoc.ru"
    
    private let tokenBaseURL = "https://sketchfab.com/oauth2/token/"
    let queryParams = ["grant_type":"password",
                       "username":"tixomark@gmail.com",
                       "password":"13579S13579"]
    
    private let modelDataURL = "https://api.sketchfab.com/v3/models"
    let myModelsListURL = "https://api.sketchfab.com/v3/me/models"
    let accessToken = "NXwJd1CTKNF2vm1IBItnezABZ3EXtt"
    let refreshToken = "121y4ILrgPBSmuaHzdomcJwxKIMf6Q"
    
    let sketchFabAPIQueue = DispatchQueue(label: "sketchFabAPIQueue", qos: .background, attributes: .concurrent)
    
    var sketchFabURLSession: URLSession!
    
    init() {
        sketchFabURLSession = URLSession(configuration: .default)
    }
    
    func getToken(completion: @escaping (Result<AccessToken, Error>) -> ()) {
        let credentials = "\(clientID):\(clientSecret)".toBase64() ?? ""
        
        var urlComponents = URLComponents(string: tokenBaseURL)!
        var queryItems: [URLQueryItem] = []
        queryParams.forEach { key, value in
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Basic " + credentials, forHTTPHeaderField: "Authorization")
        
        sketchFabURLSession.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let tokenData = try JSONDecoder().decode(AccessToken.self, from: data)
                    completion(.success(tokenData))
                } catch {
                    print("Token Data corrupted")
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getListOfMyModels(completion: @escaping (Result<MyModels, Error>) -> ()) {
        let url = URL(string: myModelsListURL)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        sketchFabURLSession.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let listOfModels = try JSONDecoder().decode(MyModels.self, from: data)
                    completion(.success(listOfModels))
                } catch {
                    print("ListOfMyModels Data corupted")
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getDowloadURLs(modelID: String, completion: @escaping (Result<FileDownloadURLs, Error>) -> ()) {
        let url = URL(string: "\(modelDataURL)/\(modelID)/download")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        sketchFabURLSession.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let downloadUrlsData = try JSONDecoder().decode(FileDownloadURLs.self, from: data)
                    
                    completion(.success(downloadUrlsData))
                } catch {
                    print("DowloadURLs Data corupted")
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}
