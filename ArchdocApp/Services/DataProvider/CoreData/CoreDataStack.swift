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
        let container = NSPersistentContainer(name: self.modelName)
        print(Thread.current)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = self.persistentContainer.viewContext
    
    func saveContext() {
//        persistentContainer.performBackgroundTask { context in
            guard managedContext.hasChanges else { return }
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
//        }
    }
    
    
    func fetchData() -> [Architecture] {
        var data: [Architecture] = []
        
//        persistentContainer.performBackgroundTask { context in
            let fetchResuest = Architecture.fetchRequest()
            do {
                data = try managedContext.fetch(fetchResuest)
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }

//        }
        return data
    }
    
}
