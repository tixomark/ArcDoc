//
//  DataProvider.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import Foundation
import UIKit

protocol DataProviderProtocol {
    
    func getArchitecture(completion: @escaping ([Architecture]) -> ())
    func loadUSDZModelFor(_ architecture: Architecture)
    func getTabBatItems() -> [TabBarItem]
    var delegate: DataProviderDownloadProgressDelegate? {get set}
    
}

class DataProvider: DataProviderProtocol {
    let sketchFabAPI: SketchfabAPI
    let networkService: NetworkService
    let coreDataStack: CoreDataStack
    
    weak var delegate: DataProviderDownloadProgressDelegate?
    var dataProviderQueue = DispatchQueue(label: "dataProvider.concurrent",
                                          qos: .userInitiated,
                                          attributes: .concurrent)
    
    init() {
        self.sketchFabAPI = SketchfabAPI()
        self.networkService = NetworkService()
        self.coreDataStack = CoreDataStack(modelName: "Architecture")
        networkService.delegate = self
        
    }
    
    func getArchitecture(completion: @escaping ([Architecture]) -> ()) {
        dataProviderQueue.async {
            let architecture = self.coreDataStack.fetchData()
            
            if !architecture.isEmpty {
                print("architecture loaded from CoreData")
                completion(architecture)
            } else {
                self.requestArchitectureList {
                    print("architecture loaded from SketchfabAPI")
                    completion(self.coreDataStack.fetchData())
                }
            }
        }
    }
    
    private func requestArchitectureList(completion: @escaping () -> ()) {
        sketchFabAPI.getListOfMyModels(completion: { [weak self] result in
            guard let tempSelf = self else {return}
            
            switch result {
            case .success(let myModelsList):
                guard let models = myModelsList.models else {return}
                let group = DispatchGroup()
                
                for model in models {
                    group.enter()
                    let previews = tempSelf.getArchitecturePreviews(of: model)
                    
                    tempSelf.coreDataStack.saveData { context in
                        let arcItem = Architecture(context: context)
                        arcItem.uid = model.uid
                        arcItem.title = model.name
                        arcItem.detail = model.tags?.description
                        arcItem.previewImages = previews
                    } completion: {
                        group.leave()
                    }
                }
                group.wait()
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
    
    private func getArchitecturePreviews(of model: Model) -> [UIImage] {
        let URLs = getArchitecturePreviewURLs(of: model)
        var images: [UIImage] = []
        let group = DispatchGroup()
        if let imageUrl = URLs.first {
//            for imageUrl in URLs {
            group.enter()
            
            networkService.loadData(at: imageUrl) { tempUrl in
                do {
                    let imageData = try Data(contentsOf: tempUrl)
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                } catch {
                    print("Can not find image at \(tempUrl)")
                }
                group.leave()
            }
        }
        group.wait()
        return images
    }
    
    func loadUSDZModelFor(_ architecture: Architecture) {
        dataProviderQueue.async {
            guard let UID = architecture.uid else { return }
            
            self.sketchFabAPI.getDowloadURLs(modelID: UID) { result in
                
                switch result {
                case .success(let modelURLs):
                    guard let url = modelURLs["usdz"]?.url,
                          let usdzURL = URL(string: url) else { return }
                    self.networkService.downloadModelOf(architecture, fromURL: usdzURL)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getTabBatItems() -> [TabBarItem] {
        return TabBarItem.items
    }
}

extension DataProvider: NetworkServiceDownloadDelegate {
    func didFinishLoadingModelOf(architecture: Architecture, to tempURL: URL) {
        guard let UID = architecture.uid else { return }
        let modelPath = FileManager.default.modelsDir.absoluteString + UID + ".usdz"
        
        guard let modelURL = URL(string: modelPath) else  { return }
        do {
            try FileManager.default.moveItem(at: tempURL, to: modelURL)
            
            self.coreDataStack.saveData { _ in
                print("saving model \(UID)")
                architecture.modelURL = modelURL
            } completion: {
                print("model \(UID) saved")
                self.delegate?.didFinishLoadingModelOf(architecture: architecture)
            }
        } catch {
            print("Can not move model at \(tempURL) to \(modelURL)")
        }
    }
    
    func currentProgress(_ progress: Float, ofDownloading arch: Architecture) {
        print("downloaded \(Int(progress * 100))% of \(arch.uid ?? "model")")
        delegate?.currentProgress(progress, ofDownloading: arch)
    }
}
    

protocol DataProviderDownloadProgressDelegate: AnyObject {
    func didFinishLoadingModelOf(architecture: Architecture)
    func currentProgress(_ progress: Float, ofDownloading arch: Architecture)
}
