//
//  CategoryViewController.swift
//  TodoMaker
//
//  Created by Eugene St on 27.01.2021.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }
    
    // MARK: - Table View Delegate methods
    // deselect row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "goToItems", sender: indexPath)
    }
    
    // delete rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            context.delete(categories[indexPath.row])
            categories.remove(at: indexPath.row)
            saveData()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? TodoMakerViewController else { return }
        guard let indexPath = sender as? IndexPath else { return }
        
        destinationVC.selectedCategory = categories[indexPath.row]
    }
    
// MARK: - IBActions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Add a category", message: "Tell me what you would like to do", preferredStyle: .alert)
        
        ac.addTextField { textField in
            textField.placeholder = "staff for home"
            textField.autocapitalizationType = .sentences
        }
        
        let okAction = UIAlertAction(title: "Okay", style: .default) { _ in
            if let text = ac.textFields?.first?.text {
                if !text.isEmpty {
                    let category = Category(context: self.context)
                    category.name = text
                    self.categories.append(category)
                    
                    self.saveData()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        ac.addAction(cancelAction)
        ac.addAction(okAction)
        
        present(ac, animated: true)
    }
    
    // MARK: - Private Methods
    private func saveData() {
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
    
    private func loadData() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }
}
