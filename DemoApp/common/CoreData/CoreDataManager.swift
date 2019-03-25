//
//  CoreDataManager.swift
//  DemoApp
//
//  Created by sumeet mourya on 24/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let sharedDatabaseManager = CoreDataManager()
    typealias VoidCompletion = () -> ()
    
    private var modelName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var persistentContainer: NSPersistentContainer? = {
        let persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return persistentContainer
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        return persistentContainer?.viewContext
    }()
    
    lazy var backgroundManagedObjectContext: NSManagedObjectContext? = {
        return persistentContainer?.newBackgroundContext()
    }()
    
    
    // MARK: - Convenience Init
    
    convenience init(modelName model: String) {
        self.init()
        modelName = model
    }
    
    func save() {
        
        guard let context = managedObjectContext else {
            return
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func deleteAllRecords(withEntityName: String) {
        
        guard let context = managedObjectContext else {
            return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: withEntityName)
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
        
    }
    
    
}
