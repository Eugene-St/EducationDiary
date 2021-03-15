//
//  CoreDataManager.swift
//  EducationDiary
//
//  Created by Eugene St on 08.02.2021.
//

import CoreData
import UIKit

private var sharedCoreDataManager: CoreDataManager!

class CoreDataManager {
    
    let context: NSManagedObjectContext
    
    class var shared: CoreDataManager {
        return sharedCoreDataManager
    }
    
    class func initialize(context: NSManagedObjectContext) {
        sharedCoreDataManager = CoreDataManager(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func deleteItem<T: NSManagedObject>(_ item: T) {
        context.delete(item)
        saveItems()
    }
    
    func saveItems() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error saving: \n \(error.localizedDescription)")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ResultClosure<[T]>) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do {
            let objects = try context.fetch(request)
            completion(.success(objects))
        } catch {
            print(error)
            completion(.failure(DataError.invalidData))
        }
    }
    
    func fetchRequest<T: NSManagedObject>(_ type: T.Type) -> NSFetchRequest<T> {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        return request
    }
    
    func resetAllRecords(in entity : String) // will remove all data from the mentioned entity
    {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
            {
                try context.execute(deleteRequest)
                try context.save()
            }
        catch
        {
            print ("There was an error while deleting all records for entity \(entity)")
        }
    }
}
