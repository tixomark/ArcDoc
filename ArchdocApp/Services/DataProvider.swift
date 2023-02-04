//
//  DataProvider.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation

protocol DataProviderProtocol {
    func getArhitectureList(completion: @escaping ([Architecture]) -> ())
    func getUSDZModelOf(architectureUID uid: String, completion: @escaping (URL) -> ()) 
    func getTabBatItems() -> [TabBarItem]
}

class DataProvider: DataProviderProtocol {
    
    let sketchFabAPI: SketchfabAPI
    let networkService: NetworkService
    
    let userDomain = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var imagesFolder, modelsFolder: URL!
    
    weak var delegate: DataProviderDelegate?
    
    init() {
        self.sketchFabAPI = SketchfabAPI()
        self.networkService = NetworkService()
        
        imagesFolder = createDir(named: "images")
        modelsFolder = createDir(named: "models")
    }
    
    func createDir(named: String) -> URL {
        var folderUrl: URL!
        if let newFolderUrl = URL(string: userDomain.absoluteString + "\(named)/") {
            do {
                try FileManager.default.createDirectory(at: newFolderUrl, withIntermediateDirectories: true)
                folderUrl = newFolderUrl
                print("Successfully created \(newFolderUrl.absoluteString)")
            } catch {
                print("An error occured while creating \(newFolderUrl.absoluteString)")
            }
        } else {
            folderUrl = userDomain
            print("Can not make user domain URL with name \(named)")
        }
        return folderUrl
    }
    
    func getArhitectureList(completion: @escaping ([Architecture]) -> ()) {
        sketchFabAPI.getListOfMyModels(completion: { [weak self] result in
            guard let tempSelf = self else {return}
            var architecture: [Architecture] = []
            
            switch result {
            case .success(let myModelsList):
                guard let models = myModelsList.models else {return}

                for model in models {
                    let tempUrls = URL(string: (model.thumbnails?.images?.first?.url) ?? "")!
                    let permanentUrls = tempSelf.getArchitectureImagesURLs(imagesUrls: [tempUrls])
                    let arcItem = Architecture(uid: model.uid!,
                                               title: model.name!,
                                               detail: "",
                                               previewImageURL: permanentUrls)
                    architecture.append(arcItem)
                }
                completion(architecture)
                
            case .failure(let error):
                completion(architecture)
                print(error.localizedDescription)
            }
        })
    }
    
    private func getArchitectureImagesURLs(imagesUrls: [URL]) -> [URL] {
        var finalUrls: [URL] = []
        let group = DispatchGroup()
        
        for imageUrl in imagesUrls {
            group.enter()
            networkService.loadData(at: imageUrl) { tempUrl in
                let finalUrl = URL(string: self.imagesFolder.absoluteString + tempUrl.lastPathComponent)!
                do {
                    try FileManager.default.moveItem(at: tempUrl, to: finalUrl)
                    finalUrls.append(finalUrl)
                } catch {
                    print("Can not move image at \(tempUrl) to \(finalUrl)")
                }
                group.leave()
            }
        }
        group.wait()
        return finalUrls
    }
    
    func getUSDZModelOf(architectureUID uid: String, completion: @escaping (URL) -> ()) {
        sketchFabAPI.getDowloadURLs(modelID: uid) { [weak self] result in
            guard let tempSelf = self else { return }
            
            switch result {
            case .success(let modelURLs):
                guard let url = modelURLs["usdz"]?.url,
                      let usdzURL = URL(string: url) else {return}
                
                tempSelf.networkService.loadData(at: usdzURL) { [weak self] tempUrl in
                    guard let tempSelf = self else { return }
                    
                    let finalUrl = URL(string: tempSelf.modelsFolder.absoluteString + tempUrl.lastPathComponent.dropLast(3) + "usdz")!
                    do {
                        try FileManager.default.moveItem(at: tempUrl, to: finalUrl)
                        print("Moved model at \(tempUrl) to \(finalUrl)")
                        completion(finalUrl)
                    } catch {
                        print("Can not move model at \(tempUrl) to \(finalUrl)")
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getTabBatItems() -> [TabBarItem] {
        return TabBarItem.items
    }
}

protocol DataProviderDelegate: AnyObject {
    
}
