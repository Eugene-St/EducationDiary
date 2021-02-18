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
    var taskViewModel: TaskViewModel?
    var delegate: TasksSecondViewControllerDelegate?
    
    // MARK: - Private Properties
    private var mediator: TasksMediator?
    private var dataToPass: [String : Any] = [:]
    
    // MARK: - View Didload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        mediator = TasksMediator()
        
        if let taskViewModel = taskViewModel {
            descriptionTextField.text = taskViewModel.task.description
            progressSlider.value = Float(taskViewModel.task.progress ?? 0)
            progressLabel.text = "\(taskViewModel.task.progress ?? 0)"
        }
    }
    
    // MARK: - IBActions
    @IBAction func progressSliderPressed(_ sender: UISlider) {
        dataToPass[Key.progress.rawValue] = Int(sender.value)
        progressLabel.text = "\(Int(sender.value))%"
        
        if taskViewModel != nil && !(descriptionTextField.text?.isEmpty ?? false) {
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        var httpMethod: HTTPMethods
        var idForHttp: String
        let timeStamp = Int(Date.timeIntervalSinceReferenceDate)
        
        // for new task
        if taskViewModel == nil {
            httpMethod = .put
            idForHttp = String(timeStamp)
            dataToPass[Key.createdOn.rawValue] = timeStamp
            dataToPass[Key.sld.rawValue] = String(timeStamp)
        
            // to update task
        } else {
            idForHttp = taskViewModel?.key ?? ""
            httpMethod = .patch
             
            // if description is not edited, will return initial text
            if descriptionTextField.text == taskViewModel?.task.description {
                dataToPass[Key.description.rawValue] = taskViewModel?.task.description
            }
            
            // if progress is not edited, will return initial value
            if progressSlider.value == Float(taskViewModel?.task.progress ?? 0) {
                dataToPass[Key.progress.rawValue] = taskViewModel?.task.progress
            }
        }
        
        let newTask = Task(createdOn: self.dataToPass[Key.createdOn.rawValue] as? Int,
                           description: self.dataToPass[Key.description.rawValue] as? String,
                           sld: self.dataToPass[Key.sld.rawValue] as? String,
                           progress: self.dataToPass[Key.progress.rawValue] as? Int)
        
        let updatedTask = Task(createdOn: taskViewModel?.task.createdOn,
                               description: dataToPass[Key.description.rawValue] as? String,
                               sld: taskViewModel?.key,
                               progress: dataToPass[Key.progress.rawValue] as? Int)
        
        mediator?.updateData(with: idForHttp, body: dataToPass, httpMethod: httpMethod, { result in
            switch result {
            
            case .success(_):
                
                switch httpMethod {
                case .put: self.delegate?.saveData(for: newTask, with: idForHttp)
                case .patch: self.delegate?.saveData(for: updatedTask, with: idForHttp)
                default: break
                }
                
                self.dismiss(animated: true)
                
                DispatchQueue.global(qos: .background).async {
                    // todo: save to core data here
                }
                
            case .failure(let error):
                Alert.noNetworkAlert(error: error)
                print(error)
                self.dismiss(animated: true, completion: nil)
            }
        })
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
        
        dataToPass[Key.description.rawValue] = text
        return true
    }
}
