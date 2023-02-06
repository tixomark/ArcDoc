//
//  DataProvider.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation

protocol DataProviderProtocol {
    var imagesFolder: URL! {get}
    var modelsFolder: URL! {get}
    
    func getArchitecture(completion: @escaping ([Architecture]) -> ())
    func getUSDZModelOf(architectureUID uid: String, completion: @escaping (URL) -> ())
    func getTabBatItems() -> [TabBarItem]
    
}

class DataProvider: DataProviderProtocol {
    
    let sketchFabAPI: SketchfabAPI
    let networkService: NetworkService
    let coreDataStack: CoreDataStack
    
    enum Paths {
        case userDomain
        case imagesFolder
        case modelsFolder
    }
    
    let userDomain = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var imagesFolder, modelsFolder: URL!
    
    weak var delegate: DataProviderDelegate?
    
    init() {
        self.sketchFabAPI = SketchfabAPI()
        self.networkService = NetworkService()
        self.coreDataStack = CoreDataStack(modelName: "Architecture")
        
        imagesFolder = createDir(named: "images")
        modelsFolder = createDir(named: "models")
    }
    
    private func createDir(named: String) -> URL {
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
    
    func getArchitecture(completion: @escaping ([Architecture]) -> ()) {
        let architecture = self.coreDataStack.fetchData()
        
        if !architecture.isEmpty {
            print("Architecture loaded from CoreData")
            completion(architecture)
        } else {
            requestArchitectureList {
                let narchitecture = self.coreDataStack.fetchData()
                print("Architecture loaded from SketchfabAPI")
                completion(narchitecture)
            }
        }
    }
    
    func requestArchitectureList(completion: @escaping () -> ()) {
        sketchFabAPI.getListOfMyModels(completion: { [weak self] result in
            guard let tempSelf = self else {return}

            switch result {
            case .success(let myModelsList):
                guard let models = myModelsList.models else {return}
                
                for model in models {
                    let previewFileNames = tempSelf.getArchitecturePreviews(of: model)

                    tempSelf.coreDataStack.managedContext.perform {
                        
                        let arcItem = Architecture(context: tempSelf.coreDataStack.managedContext)
                        arcItem.uid = model.uid
                        arcItem.title = model.name
                        arcItem.detail = model.tags?.description
//                        arcItem.previewImageFileNames = previewFileNames

                        tempSelf.coreDataStack.saveContext()
                    }
                }
                completion()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func getArchitecturePreviewURLs(of model: Model) -> [URL] {
        var modelPreviewUrls: [URL] = []
        
        if let modelPreviews = model.thumbnails?.images {
            for image in modelPreviews {
                if let url = image.url {
                    modelPreviewUrls.append(URL(string: url)!)
                }
            }
        }
        
        return modelPreviewUrls
    }
    
    private func getArchitecturePreviews(of model: Model) -> [String] {
        let URLs = getArchitecturePreviewURLs(of: model)
        var fileNames: [String] = []
        let group = DispatchGroup()
        
        for imageUrl in URLs {
            group.enter()
            
            networkService.loadData(at: imageUrl) { tempUrl in
                let fileName = String(tempUrl.lastPathComponent.dropLast(3).dropFirst(18)) + "png"
                let finalUrl = URL(string: self.imagesFolder.absoluteString + fileName)!
                
                do {
                    try FileManager.default.moveItem(at: tempUrl, to: finalUrl)
                    fileNames.append(fileName)
                } catch {
                    print("Can not move image at \(tempUrl) to \(finalUrl)")
                }
                group.leave()
            }
        }
        group.wait()
        return fileNames
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
//                        print("Moved model at \(tempUrl) to \(finalUrl)")
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
