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
    private var dataToPass: [String: Any] = [:]
    
    // MARK: - View Didload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        saveButton.isEnabled = false
        
        mediator = TasksMediator()
        
        if let taskViewModel = taskViewModel {
            descriptionTextField.text = taskViewModel.task.description
            progressSlider.value = Float(taskViewModel.task.progress ?? 0)
            progressLabel.text = "\(taskViewModel.task.progress ?? 0)"
        }
    }
    
    // MARK: - IBActions
    @IBAction func progressSliderPressed(_ sender: UISlider) {
        dataToPass["progress"] = Int(sender.value)
        progressLabel.text = "\(Int(sender.value))%"
        saveButton.isEnabled = taskViewModel != nil ? true : false
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        var httpMethod: HTTPMethods
        var idForHttp: String
        let timeStamp = Int(Date.timeIntervalSinceReferenceDate)
        
        if taskViewModel == nil {
            httpMethod = .put
            idForHttp = String(timeStamp)
            dataToPass["createdOn"] = timeStamp
            dataToPass["sld"] = String(timeStamp)
        } else {
            idForHttp = taskViewModel?.key ?? ""
            httpMethod = .patch
            dataToPass["description"] = taskViewModel?.task.description
            // dataToPass["progress"] = taskViewModel?.task.progress // updates task name with saved progress
        }
        
        let newTask = Task(createdOn: self.dataToPass["createdOn"] as? Int,
                           description: self.dataToPass["description"] as? String,
                           sld: self.dataToPass["sld"] as? String,
                           progress: self.dataToPass["progress"] as? Int)
        
        let updatedTask = Task(createdOn: taskViewModel?.task.createdOn,
                               description: dataToPass["description"] as? String,
                               sld: taskViewModel?.key,
                               progress: dataToPass["progress"] as? Int)
        
        mediator?.updateData(with: idForHttp, body: dataToPass, httpMethod: httpMethod, { result in
            switch result {
            
            case .success(_):
                
                if httpMethod == .put {
                    self.delegate?.saveData(for: newTask, with: idForHttp)
                } else {
                    self.delegate?.saveData(for: updatedTask, with: idForHttp)
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
        
        dataToPass["description"] = text
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: descriptionTextField, queue: OperationQueue.main) { _ in
            
            let textCount = self.descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            let textIsNotEmpty = textCount > 0
            self.saveButton.isEnabled = textIsNotEmpty
        }
        
        return true
    }
}
