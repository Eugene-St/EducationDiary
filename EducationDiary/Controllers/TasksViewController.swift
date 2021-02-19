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
    private var mediator: TasksMediator?
    private var tasksViewModels = [TaskViewModel]()
    
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
                tasks.forEach { key, task in
                    self.tasksViewModels.append(TaskViewModel(task: task, key: key))
                }
                self.tableView.reloadData()
           
            case .failure(let error):
                print("BookmarksMediator ERROR:\(error.localizedDescription)")
                Alert.noNetworkAlert(error: error)
            }
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print(view.bounds.width)
    }
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TasksCell
        
        cell.configure(with: tasksViewModels[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {

            let taskViewModel = tasksViewModels[indexPath.row]

            mediator?.deleteData(with: taskViewModel.key, { result in
                switch result {

                case .success(_):
                    self.tasksViewModels.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)

                case .failure(let error):
                    print("No internet!", error)
                    Alert.noNetworkAlert(error: error)
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

            popover.sourceView = tableView.cellForRow(at: indexPath)
            vc.taskViewModel = tasksViewModels[indexPath.row]
            present(vc, animated: true)
        }
    }
    
    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                let cell = tableView.cellForRow(at: indexPath)
                
                let taskViewModel = tasksViewModels[indexPath.row]
                
                mediator?.updateData(with: taskViewModel.key, body: [Key.progress.rawValue: 100], httpMethod: .patch, { result in
                    
                    switch result {
                    
                    case .success(_):
                        
//                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        taskViewModel.isCompleted = true
                        cell?.accessoryType = taskViewModel.accessoryType
                        cell?.textLabel?.attributedText = taskViewModel.task.description?.strikeThrough()
                        cell?.tintColor = taskViewModel.tintColor

                    case .failure(let error):
                        Alert.noNetworkAlert(error: error)
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
        
        let newTaskModel = TaskViewModel(task: task, key: id)
        
        if let index = tasksViewModels.firstIndex(where: { $0.key == newTaskModel.key }) {
            tasksViewModels[index] = newTaskModel
        }
        
        let newModels = tasksViewModels.filter { $0.key == newTaskModel.key }
        if newModels.count == 0 {
            tasksViewModels.append(newTaskModel)
        }
        self.tableView.reloadData()
    }
}
