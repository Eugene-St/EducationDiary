//
//  CoreDataManager.swift
//  EducationDiary
//
//  Created by Eugene St on 08.02.2021.
//

import CoreData
import UIKit

struct CoreDataManager {
    private init(){}
    static let shared = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func deleteItem<T: NSManagedObject>(_ item: T){
        context.delete(item)
        saveItems()
    }
    
    func saveItems() {
        if context.hasChanges {
            do {
                try context.save()
                NotificationCenter.default.post(name: NSNotification.Name("PersistedDataUpdated"), object: nil)
                print("saved data")
            } catch {
                let nserror = error as NSError
                print("Error saving: \n \(error.localizedDescription)")
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ResultClosure<[NSManagedObject]>) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        
        do {
        let objects = try context.fetch(request)
            completion(.success(objects))
        } catch {
            print(error)
            completion(.failure(DataError.invalidData))
        }
    }
    
    func loadItems(with request: NSFetchRequest<NSFetchRequestResult>) -> [Any] {
        do {
            return try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
            
        }
    }
    
    
}
