//
//  Download.swift
//  ArchdocApp
//
//  Created by tixomark on 2/8/23.
//

import Foundation

class Download {
    var architecture: Architecture
    var isDownloading: Bool = false
    var progress: Float = 0
    var task: URLSessionDownloadTask?
    
    init(architecture: Architecture) {
        self.architecture = architecture
    }
}
