//
//  CoreDataManager.swift
//  DemoApp
//
//  Created by sumeet mourya on 24/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import CoreData

//https://www.oreilly.com/library/view/ios-10-swift/9781491966426/ch04.html
//https://useyourloaf.com/blog/cleaning-up-core-data-fetch-requests/

class CoreDataManager {
    
    static let AlbumStoringModifiedNotification = Notification.Name("McdCardioDoneNotification")
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
    
    func save() -> Bool {
        
        guard let context = managedObjectContext else {
            return false
        }
        
        if context.hasChanges {
            do {
                try context.save()
                print("save your Data")
                return true
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return true
    }
    
    // This will give Entire Entity data for given Type of object

    func fetchEntireDataData<T: NSManagedObject> (_ objectType: T.Type) -> [T] {
        
        let entityName:String = String(describing: objectType)
       
        guard let context = managedObjectContext else {
            return [T]()
        }

        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let fetchObjects = try context.fetch(fetch) as? [T]
            return fetchObjects ?? [T]()
        } catch {
            print("error")
            return [T]()
        }
        
    }
    
    // This will give the array of type T data according to given Fetch Request
    
    func fetchData<T> (_ requestValue: NSFetchRequest<T>) -> [T] {
        
        guard let context = managedObjectContext else {
            return [T]()
        }
        
        do {
            let fetchObjects = try context.fetch(requestValue)
            return fetchObjects
        } catch {
            print("error")
            return [T]()
        }
        
    }
    
    //This method will be delete only the given ManagedObject
    
    func delete(_ object: NSManagedObject) {
        guard let context = managedObjectContext else {
            return
        }

        context.delete(object)
        print("Delete operation succeed: \(save())")
    }
    
    //This Method will delete the recods whose are will get from the NSFetchRequest query
    
    func deleteRecords(_ requestValue: NSFetchRequest<NSFetchRequestResult>) -> Bool {
        
        guard let context = managedObjectContext else {
            return false
        }

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: requestValue)
        
        do {
            try context.execute(batchDeleteRequest)
            return true
        } catch {
            return false
        }
        
    }

    // This will Delete the whole Entity Data for given Entity Name
    
    func deleteAllRecords(withEntityName: String) -> Bool {
        
        guard let context = managedObjectContext else {
            return false
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: withEntityName)
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            return true
        } catch {
            // Error Handling
            return false
        }
        
    }
    

}
