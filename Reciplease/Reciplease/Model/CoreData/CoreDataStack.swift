//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by TomF on 02/11/2022.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: - Singleton
    static let shared: CoreDataStack = CoreDataStack(modelName: "Reciplease")
    var persistentContainer: NSPersistentContainer

    
    // MARK: - Init
    init(modelName: String, persistentStoreDescription: String? = nil) {
        let description = NSPersistentStoreDescription()
        if let persistentStoreDescription {
            description.url = URL(fileURLWithPath: persistentStoreDescription)
        }
        
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            guard let unwrappedError = error else { return }
            fatalError("Unresolved error \(unwrappedError.localizedDescription)")
        })
        
    }
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

//MARK: Method to save
    func saveContext() {
        do {
            try mainContext.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
