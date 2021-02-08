//
//  CoreDataManager.swift
//  EducationDiary
//
//  Created by Eugene St on 08.02.2021.
//

import CoreData
import UIKit

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func deleteItem<T: NSManagedObject>(_ item: T){
        context.delete(item)
        saveItems()
    }
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("Error saving: \n \(error.localizedDescription)")
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
    
    private init(){}
}
