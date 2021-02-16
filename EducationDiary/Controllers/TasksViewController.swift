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
        
        // add long press gesture
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.tableView.addGestureRecognizer(longPressRecognizer)
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TasksCell
        cell.configure(with: tasks, indexPath: indexPath)
        
        return cell
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            var tasksKeys = Array(tasks.keys)
            let taskKey = tasksKeys[indexPath.row]
            let taskID = "\(taskKey).json"
//            print(tasksKeys)
            
            mediator?.deleteData(with: taskID, { result in
                switch result {
                
                case .success(_):
                    self.tasks.removeValue(forKey: tasksKeys[indexPath.row])
//                    print("task key to remove \(tasksKeys[indexPath.row])")
                    tasksKeys.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
//                    print(tasksKeys)
                case .failure(let error):
                    print("No internet!")
//                    self.noNetworkAlert(error: error)
                }
            })
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentPopOver(with: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func addTaskButtonPressed(_ sender: UIBarButtonItem) {
        presentPopOver(for: sender)
    }
    
    // MARK: - Private Methods
    // popover
    private func presentPopOver(for button: UIBarButtonItem? = nil, with indexPath: IndexPath? = nil) {
        guard let vc = storyboard?.instantiateViewController(identifier: "tasksPopVC") as? TasksSecondViewController else { return }
        
        vc.modalPresentationStyle = .popover
        vc.delegate = self
        guard let popover = vc.popoverPresentationController else { return }
        popover.delegate = self
        
        if button != nil {
            popover.barButtonItem = button
            present(vc, animated: true)
        } else {
            guard let indexPath = indexPath else { return }

            let taskKeys = Array(tasks.keys)
            let task = tasks[taskKeys[indexPath.row]]
            popover.sourceView = tableView.cellForRow(at: indexPath)
            vc.task = task
            present(vc, animated: true)
        }
    }
    
    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                let cell = tableView.cellForRow(at: indexPath)
                
//                let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TasksCell
                
                let taskKeys = Array(tasks.keys)
                let task = tasks[taskKeys[indexPath.row]]
                
                print("long press \(task?.description)")
                print(cell?.textLabel?.text)
                
                mediator?.updateData(with: task?.sld, body: ["progress": 100], httpMethod: .patch, { result in
                    
                    switch result {
                    
                    case .success(_):
                        
                        cell?.textLabel?.attributedText = task?.description?.strikeThrough()
                        cell?.accessoryType = .checkmark
                        cell?.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
//                        self.tableView.reloadRows(at: [indexPath], with: .top)
//                        self.tableView.reloadData()
                    case .failure(_):
                        print("failure")
                    }
                })
            }
        }
    }
    
    // MARK: - Navigation

}

// MARK: - Popover Delegate
extension TasksViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

// MARK: - TasksSecondViewControllerDelegate
extension TasksViewController: TasksSecondViewControllerDelegate {
    func saveData(for task: Task, with id: String) {
        self.tasks[task.sld ?? ""] = task
        self.tableView.reloadData()
    }
}
