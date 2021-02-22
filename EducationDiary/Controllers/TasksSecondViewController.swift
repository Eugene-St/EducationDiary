//
//  TasksSecondViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class TasksSecondViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    // MARK: - Public Properties
    var task: Task?
    var delegate: TasksSecondViewControllerDelegate?
    
    // MARK: - Private Properties
    private lazy var mediator = TasksMediator()
    
    // MARK: - View Didload
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        loadData()
    }
    
    // MARK: - IBActions
    @IBAction func progressSliderPressed(_ sender: UISlider) {
        progressSlider.value = sender.value
        progressLabel.text = "\(Int(sender.value))%"
        
        if task != nil && !(descriptionTextField.text?.isEmpty ?? false) {
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if task == nil {
            createNewTask()
        } else {
            updateTask()
        }
    }
    
    // MARK: - Private Methods
    // Create new task
    private func createNewTask() {
        
        let timeStamp = Int(Date.timeIntervalSinceReferenceDate)
        
        let task = Task(createdOn: timeStamp,
                        description: descriptionTextField.text,
                        sld: String(timeStamp),
                        progress: Int(progressSlider.value))
        
        mediator.createNewData(for: task) { result in
            
            switch result {
            
            case .success(_):
                print("success creation")
                self.delegate?.saveData(for: task, with: String(timeStamp))
                self.dismiss(animated: true)
            case .failure(let error):
                Alert.errorAlert(error: error) //
                print("could not create")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Update task
    private func updateTask() {
        
        let task = Task(createdOn: self.task?.createdOn,
                        description: descriptionTextField.text,
                        sld: self.task?.sld,
                        progress: Int(progressSlider.value))
        
        mediator.updateData(for: task) { result in
            switch result {
            
            case .success(_):
                print("updated Data")
                self.delegate?.saveData(for: task, with: self.task?.sld ?? "")
                self.dismiss(animated: true)
                
                DispatchQueue.global(qos: .background).async {
                    // todo: save to core data here
                }
                
            case .failure(let error):
                Alert.errorAlert(error: error)
                print("Could not update data")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Load data
    private func loadData() {
        if let task = task {
            descriptionTextField.text = task.description
            progressSlider.value = Float(task.progress ?? 0)
            progressLabel.text = "\(task.progress ?? 0)"
        }
    }
}

// MARK: - UITextFieldDelegate Extension
extension TasksSecondViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if !text.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        return true
    }
}
