//
//  CoreDataStack.swift
//  FS 70
//
//  Created by antoine fenouillot on 06/09/2024.
//

import Foundation
import CoreData

final class CoreDataStack {

    // MARK: - Singleton

    static let sharedInstance = CoreDataStack()

    // MARK: - Context

    //Context for all data
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
    }
    
    

    // MARK: - PersistentContainer

    private lazy var persistentContainer: NSPersistentContainer = {
        
        // Create the persistent container and point to the xcdatamodeld - so matches the xcdatamodeld filename
               let container = NSPersistentContainer(name: "France_Services_70")
                
                // load the database if it exists, if not create it.
                container.loadPersistentStores { storeDescription, error in
                    // resolve conflict by using correct NSMergePolicy
                    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                    
                    if let error = error {
                        print("Unresolved error \(error)")
                    }
                }
        return container
    }()
    
   
}

