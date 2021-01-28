//
//  TodoMakerViewController.swift
//  TodoMaker
//
//  Created by Eugene St on 26.01.2021.
//

import UIKit
import CoreData

class TodoMakerViewController: UITableViewController {
    
    var tasks: [Task] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category? {
        didSet {
            loadTasks()
        }
    }
    
//    var context: NSManagedObjectContext!
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Tasks.plist")
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
}
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        
        cell.accessoryType = task.isFinished ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell pressed")
  
//        tasks[indexPath.row].setValue("Completed", forKey: "name")
        
        tasks[indexPath.row].isFinished.toggle()
//        tasks[indexPath.row].isFinished = !tasks[indexPath.row].isFinished
        
        
//        context.delete(tasks[indexPath.row])
//        tasks.remove(at: indexPath.row)
        
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
//        saveDataToFile()
        
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        cell.alpha = 0
//
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0.03 * Double(indexPath.row)) {
//            cell.alpha = 1
//        }
//    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let Approve = UITableViewRowAction(style: .normal, title: "УДАЛИТЬ!") { action, index in
//
//            self.context.delete(self.tasks[indexPath.row])
//            self.tasks.remove(at: indexPath.row)
//            self.saveData()
//            }
//            Approve.backgroundColor = .red
//            return [Approve]
//    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(tasks[indexPath.row])
            tasks.remove(at: indexPath.row)
            saveData()
        }
    }
    
    // MARK: - IBActions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Make a wish", message: "Tell me your wish and I'll make it come true", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Okay", style: .default) { _ in
            if let text = ac.textFields?.first?.text {
                if !text.isEmpty {
                    
                    let task = Task(context: self.context)
                    task.name = text
                    task.isFinished = false
                    task.parentCategory = self.selectedCategory
                    self.tasks.append(task)
                    self.saveData()
//                    self.saveDataToFile()
                }
            }
        }
        
        ac.addTextField { textField in
            textField.placeholder = "I want an icecream"
            textField.autocapitalizationType = .sentences
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        ac.addAction(cancelAction)
        ac.addAction(okAction)
        present(ac, animated: true)
        
    }
    
    private func saveData() {
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
            print("error saving context")
        }
        tableView.reloadData()
    }
    
//    private func saveDataToFile() {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let data = try encoder.encode(tasks)
//            try data.write(to: dataFilePath!)
//        } catch {
//            print("Error in encoding item array")
//        }
//
//        self.tableView.reloadData()
//    }
    
    
    private func loadTasks(with request: NSFetchRequest<Task> = Task.fetchRequest(), and predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            tasks = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
//    private func loadTasks() {
//        if let data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//            tasks = try decoder.decode([Task].self, from: data)
//            } catch {
//                print("Error while decoding the data")
//            }
//        }
//    }
    
}

// MARK: - SearchBar Delegate
extension TodoMakerViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadTasks(with: request, and: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTasks()
            print(Thread.current)
            DispatchQueue.main.async {
                print(Thread.current)
                searchBar.resignFirstResponder()
            }
        }
    }
}
