//
//  MainTableViewController.swift
//  ArchdocApp
//
//  Created by tixomark on 1/21/23.
//

import UIKit

class MainViewController: UIViewController {
    
    private struct Values {
        static let architectureCellID = "ArchCell"
        static let noImage = "noImage"
    }
    
    @IBOutlet weak var architectureCatalogueTable: UITableView!
    
    var presenter: MainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        architectureCatalogueTable.delegate = self
        architectureCatalogueTable.dataSource = self
        architectureCatalogueTable.register(ArchitectureTableCell.self,
                                            forCellReuseIdentifier: Values.architectureCellID)
        architectureCatalogueTable.separatorStyle = .none
    }
    
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.architecture?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Values.architectureCellID, for: indexPath) as! ArchitectureTableCell
        
        cell.configure(architecture: presenter.architecture?[indexPath.row], imageDir: presenter.dataProvider.imagesFolder)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var imageSize: CGSize = CGSize(width: 1, height: 1)

//        if let _ = presenter.architecture?[indexPath.row].previewImageFileNames?.first {
//            imageSize = presenter.getArchitectureImageDimensions(index: indexPath.row)
//        }

        let imageAspectRatio = Float(imageSize.height / imageSize.width)
        let inset: Float = 10
        let cellHeight = (Float(tableView.frame.width) - inset * 2) * imageAspectRatio + inset * 3 + 50

        return CGFloat(cellHeight)
    }
    
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let architecture = presenter.architecture?[indexPath.row]
        presenter.tapOnCell(architecture: architecture)
    }
}

extension MainViewController: MainViewProtocol {
    func reloadTable() {
        
        architectureCatalogueTable.reloadData()
    }
    
    func getDimensionsOfImage(url: URL) -> CGSize? {
        // with CGImageSource we avoid loading the whole image into memory
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }
        
        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }
        
        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
           let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
            return CGSize(width: width, height: height)
        } else {
            return nil
        }
    }
}
