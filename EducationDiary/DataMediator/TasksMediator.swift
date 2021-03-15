//
//  TasksMediator.swift
//  EducationDiary
//
//  Created by Eugene St on 01.02.2021.
//

import UIKit

class TasksMediator: Mediator<Tasks> {
    init() {
        super.init(.tasks, pathForUpdate: .tasksUpdate)
    }
    
    // save to DB
    override func saveToDB(_ model: Tasks) {
        model.forEach { (_, task) in
            let taskCD = TaskCoreData(context: CoreDataManager.shared.context)
            taskCD.createdOn = task.createdOn ?? 0
            taskCD.taskDescription = task.description
            taskCD.progress = task.progress ?? 0
            taskCD.sld = task.sld
            CoreDataManager.shared.saveItems()
        }
    }
    
    // fetch from DB
    override func fetchFromDB(_ completion: @escaping ResultClosure<Tasks>) {
        CoreDataManager.shared.fetch(TaskCoreData.self) { result in
            switch result {
            
            case .success(let taskObjects):
                var tasks: [String : Task] = [:]
                
                taskObjects.forEach { taskObject in
                    tasks[taskObject.sld ?? ""] = Task(
                        createdOn: taskObject.createdOn,
                        description: taskObject.taskDescription,
                        sld: taskObject.sld,
                        progress: taskObject.progress)
                }
                
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // delete single entity from db
    override func deleteFromDB(_ model: Model) {
        let request = CoreDataManager.shared.fetchRequest(TaskCoreData.self)
        
        do {
            let objects = try CoreDataManager.shared.context.fetch(request)
            
            objects.forEach { taskCD in
                if model.modelId == taskCD.sld {
                    CoreDataManager.shared.deleteItem(taskCD)
                    CoreDataManager.shared.saveItems()
                }
            }
        } catch {
            let nserror = error as NSError
            print("Error deleting: \n \(error.localizedDescription)")
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            
        }
    }
    
    override func updateInDB(_ model: Model) {
        let request = CoreDataManager.shared.fetchRequest(TaskCoreData.self)
        
        do {
            let objects = try CoreDataManager.shared.context.fetch(request)
            
            objects.forEach { taskCD in
                let task = model as! Task
                if model.modelId == taskCD.sld {
                    taskCD.createdOn = task.createdOn ?? 0
                    taskCD.progress = task.progress ?? 0
                    taskCD.taskDescription = task.description
                    taskCD.sld = task.sld
                    CoreDataManager.shared.saveItems()
                }
            }
            
        } catch {
            let nserror = error as NSError
            print("Error updating: \n \(error.localizedDescription)")
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    override func createInDB(_ model: Model) {
        let task = model as! Task
        let taskCD = TaskCoreData(context: CoreDataManager.shared.context)
        taskCD.createdOn = task.createdOn ?? 0
        taskCD.progress = task.progress ?? 0
        taskCD.sld = task.sld
        taskCD.taskDescription = task.description
        CoreDataManager.shared.saveItems()
    }
    
    // delete all entities from DB
    override func deleteEntitiesFromDB() {
        CoreDataManager.shared.resetAllRecords(in: "TaskCoreData")
    }
}
