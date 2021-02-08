//
//  TasksViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class TasksViewController: UITableViewController {

    // MARK: - Private Properties
    private var tasks = Tasks()
    private var mediator: TasksMediator?
    
    // MARK: - View DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediator = TasksMediator()
        
        mediator?.fetchData({ result in
            switch result {
            
            case .success(let tasks):
                self.tasks = tasks
                self.tableView.reloadData()
            case .failure(let error):
                print("BookmarksMediator ERROR:\(error.localizedDescription)")
            }
        })
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let taskKeys = Array(tasks.keys)
        let task = tasks[taskKeys[indexPath.row]]

        cell.textLabel?.text = task?.description
        cell.detailTextLabel?.text = "Progress = \(task?.progress ?? 0.0)"

        return cell
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            print("Edited")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - IBActions
    
    
    // MARK: - Private methods
}
