//
//  NetworkService.swift
//  ArchdocApp
//
//  Created by tixomark on 2/2/23.
//

import Foundation

class NetworkService: NSObject {
    
    private lazy var serviceURLSession: URLSession = {
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: nil)
        return session
    }()
    weak var delegate: NetworkServiceDownloadDelegate?
    
    private var activeDownloads: [URL : Download] = [:]
        
    func loadData(at atURL: URL, completion: @escaping (URL) -> ()) {
        let downloadTask = serviceURLSession.downloadTask(with: atURL) { url, response, error in
            if let url = url {
                completion(url)
            } else if let error = error {
                print(error.localizedDescription)
                print("Can not load data at \(atURL)")
            }
        }
        downloadTask.resume()
        
    }
    
    func downloadModelOf(_ arch: Architecture, fromURL: URL) {
        let download = Download(architecture: arch)
        download.task = serviceURLSession.downloadTask(with: fromURL)
        download.task?.resume()
        download.isDownloading = true
        activeDownloads[fromURL] = download
    }
    
}

extension NetworkService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let downloadURL = downloadTask.originalRequest?.url else { return }
        let download = activeDownloads[downloadURL]
        
        guard let arch = download?.architecture else { return }
        delegate?.didFinishLoadingModelOf(architecture: arch, to: location)
        activeDownloads.removeValue(forKey: downloadURL)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard let downloadURL = downloadTask.originalRequest?.url else { return }
        let download = activeDownloads[downloadURL]
        
        guard let arch = download?.architecture else { return }
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        delegate?.currentProgress(progress, ofDownloading: arch)
    }
    
}

protocol NetworkServiceDownloadDelegate: AnyObject {
    func didFinishLoadingModelOf(architecture: Architecture, to tempURL: URL)
    func currentProgress(_ progress: Float, ofDownloading arch: Architecture)
}

