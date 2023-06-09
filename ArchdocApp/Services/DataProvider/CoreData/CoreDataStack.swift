//
//  CoreDataStack.swift
//  ArchdocApp
//
//  Created by tixomark on 2/5/23.
//

import Foundation
import CoreData

class CoreDataStack {
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        UIImageToDataTrasformer.register()
        URLToStringTransformer.register()
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private lazy var managedContext: NSManagedObjectContext = self.persistentContainer.viewContext
    
    func saveData(block: @escaping (NSManagedObjectContext) -> (),
                  completion: @escaping () -> () = {}) {
        block(managedContext)
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
            print("data saved on \(Thread.current)")
            completion()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchData() -> [Architecture] {
        var data: [Architecture] = []
        let fetchResuest = Architecture.fetchRequest()
        do {
            data = try managedContext.fetch(fetchResuest)
            print("data fetched on \(Thread.current)")
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return data
    }

    
}
