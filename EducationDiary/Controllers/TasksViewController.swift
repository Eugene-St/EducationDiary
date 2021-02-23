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
    private lazy var mediator = TasksMediator()
    private var taskViewModels = [TaskViewModel]()
    
    private var refresh: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action:
                         #selector(TasksViewController.handleRefresh(_:)),
                                     for: UIControl.Event.valueChanged)
            refreshControl.tintColor = #colorLiteral(red: 0.2709907293, green: 0.2985699177, blue: 0.3308950067, alpha: 1)
            return refreshControl
        }()
    
    // MARK: - View DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.addSubview(self.refresh)
        // add long press gesture
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.tableView.addGestureRecognizer(longPressRecognizer)
        
        loadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskViewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TasksCell
        
        cell.configure(with: taskViewModels[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {

            let taskViewModel = taskViewModels[indexPath.row]
            
            mediator.deleteData(for: taskViewModel.task) { result in
                switch result {
                    
                case .success(_):
                    self.taskViewModels.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)

                case .failure(let error):
                    print("No internet!", error)
                    Alert.errorAlert(error: error) // todo: не обязательно тут не будет интернета!!! првоерить
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentTasksSecondVCPopOver(for: taskViewModels[indexPath.row].task, with: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - IBActions
    @IBAction func addTaskButtonPressed(_ sender: UIBarButtonItem) {
        presentTasksSecondVCPopOver()
    }
    
    // MARK: - Private Methods
    
    // Load Data
    private func loadData() {
        mediator.fetchData({ result in
            switch result {
            
            case .success(let tasks):
                tasks.forEach { [weak self] key, task in
                    self?.taskViewModels.append(TaskViewModel(task: task, key: key))
                }
                self.tableView.reloadData()
           
            case .failure(let error):
                print("BookmarksMediator ERROR:\(error.localizedDescription)")
                Alert.errorAlert(error: error)
            }
        })
    }
    
    // Popover
    private func presentTasksSecondVCPopOver(for task: Task? = nil, with indexPath: IndexPath? = nil) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "tasksPopVC") as? TasksSecondViewController else { return }
        
        vc.modalPresentationStyle = .popover
        vc.delegate = self
        
        guard let popover = vc.popoverPresentationController else { return }
        popover.delegate = self
        
        if task != nil {
            guard let indexPath = indexPath else { return }
            popover.sourceView = tableView.cellForRow(at: indexPath)
            vc.task = task
            present(vc, animated: true)
        } else {
            popover.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    }
    
    // Long press recognizer
    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                
                let taskViewModel = taskViewModels[indexPath.row]
                
                // todo: тут по хорошему должна быть блокировка интерфейса(экрана)
                
                taskViewModel.task.progress = 100
                
                mediator.updateData(for: taskViewModel.task) { result in
                    
                    switch result {
                    
                    case .success(_):
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)

                    case .failure(let error):
                        Alert.errorAlert(error: error)
                    }
                }
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        taskViewModels.removeAll()
            loadData()
            refreshControl.endRefreshing()
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
        
        if let index = taskViewModels.firstIndex(where: { $0.key == newTaskModel.key }) {
            taskViewModels[index] = newTaskModel
        }
        
        let newModels = taskViewModels.filter { $0.key == newTaskModel.key }
        if newModels.count == 0 {
            taskViewModels.insert(newTaskModel, at: 0)
        }
        
//        self.tableView.insertRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        self.tableView.reloadData()
    }
}
