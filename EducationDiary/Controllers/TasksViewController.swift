//
//  TasksViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class TasksViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    
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
//        cell.detailTextLabel?.text = "Progress = \(task?.progress ?? 0.0)"

        return cell
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let tasksKeys = Array(tasks.keys)
            let taskKey = tasksKeys[indexPath.row]
            let taskID = "\(taskKey).json"
            
            mediator?.deleteData(with: taskID, { result in
                switch result {
                
                case .success(_):
                    self.tasks.removeValue(forKey: tasksKeys[indexPath.row])
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                case .failure(let error):
                    print("No internet!")
//                    self.noNetworkAlert(error: error)
                }
            })
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presentPopOver(with: indexPath)
//        performSegue(withIdentifier: "tasksPopVC", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func addTaskButtonPressed(_ sender: UIBarButtonItem) {
        presentPopOver(for: sender)
    }
    
    // MARK: - Private Methods
    private func presentPopOver(for button: UIBarButtonItem? = nil, with indexPath: IndexPath? = nil) {
        guard let vc = storyboard?.instantiateViewController(identifier: "tasksPopVC") else { return }
        
        vc.modalPresentationStyle = .popover
        guard let popover = vc.popoverPresentationController else { return }
        popover.delegate = self
        
        if button != nil {
            popover.barButtonItem = button
            present(vc, animated: true)
        } else {
            guard let indexPath = indexPath else { return }
            popover.sourceView = tableView.cellForRow(at: indexPath)
            present(vc, animated: true)
        }
    }
    
    // MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "EditTaskSegue" {
//            let popoverTaskVC = segue.destination as! TasksSecondViewController
//            popoverTaskVC.modalPresentationStyle = .popover
//            guard let popover = popoverTaskVC.popoverPresentationController else { return }
//            popover.delegate = self
//
//            popover.permittedArrowDirections = .down
//            guard let cell = tableView.cellForRow(at: sender as! IndexPath) else { return }
//            popover.sourceView = cell
//            popover.sourceRect = cell.bounds
//        }
//    }
}

extension TasksViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

extension TasksViewController: TasksSecondViewControllerDelegate {
    func saveData(for task: Task, with id: String) {
        print("saved")
        self.tasks[id] = task
        self.tableView.reloadData()
    }
    
    
}
