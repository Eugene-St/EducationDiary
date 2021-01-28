//
//  MainViewController.swift
//  DemoCoreData
//
//  Created by Eugene St on 22.01.2021.
//

import UIKit
import CoreData

class MainViewController: UITableViewController {
    
    private var tasks: [Task] = []

    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        print(tasks.count)
        
        let context = getContext()
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) // to sort the data
        fetchRequest.sortDescriptors = [sortDescriptor] // to sort the data
        
        do {
            tasks = try context.fetch(fetchRequest)
            deleteButton.isEnabled = tasks.count > 0 ? true : false
            print("In fetch request \(tasks.count)")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Add new task", message: "Please add new task", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let textField = ac.textFields?.first
            
            if let newTaskTitle = textField?.text {
                self.saveTask(withTitle: newTaskTitle)
                self.deleteButton.isEnabled = true
                self.tableView.reloadData()
            }
            
        }
        
        ac.addTextField { textField in
            textField.autocapitalizationType = .sentences
            textField.placeholder = "some task"
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { _ in
                
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0

                let textIsNotEmpty = textCount > 0
                
                saveAction.isEnabled = textIsNotEmpty
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        ac.addAction(cancel)
        saveAction.isEnabled = false
        ac.addAction(saveAction)
        present(ac, animated: true)
    }
    
    // MARK: - Core Data remove
    @IBAction func removeTasks(_ sender: UIBarButtonItem) {
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        if let results = try? context.fetch(fetchRequest) {
            for object in results {
                context.delete(object)
            }
        }
        
        do {
            try context.save()
            tasks = []
            deleteButton.isEnabled = false
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    
    // MARK: - Save data to Core Data!
    private func saveTask(withTitle title: String) {
        
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        
        do {
            try context.save()
//            tasks.append(taskObject)
            let indexPath = IndexPath(row: tasks.count, section: 0)
            tasks.insert(taskObject, at: tasks.count )
            tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }
}
