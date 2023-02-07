//
//  Architecture+CoreDataProperties.swift
//  ArchdocApp
//
//  Created by tixomark on 2/7/23.
//
//

import Foundation
import CoreData
import UIKit

extension Architecture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Architecture> {
        return NSFetchRequest<Architecture>(entityName: "Architecture")
    }

    @NSManaged public var detail: String?
    @NSManaged public var modelURL: URL?
    @NSManaged public var previewImages: [UIImage]?
    @NSManaged public var title: String?
    @NSManaged public var uid: String?

}

extension Architecture : Identifiable {

}
