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
    private var mediator: TasksMediator?
    private var dataToPass: [String: Any] = [:]
    
    // MARK: - View Didload
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        
        mediator = TasksMediator()
        
        if let task = task {
            descriptionTextField.text = task.description
            progressSlider.value = Float(task.progress ?? 0)
            progressLabel.text = "\(task.progress ?? 0)"
        }
    }
    
    // MARK: - IBActions
    @IBAction func progressSliderPressed(_ sender: UISlider) {
        dataToPass["progress"] = Int(sender.value)
        progressLabel.text = "\(Int(sender.value))%"
        saveButton.isEnabled = task != nil ? true : false
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {

        var httpMethod: HTTPMethods
        var idForHttp: String
        let timeStamp = Int(Date.timeIntervalSinceReferenceDate)

        if task == nil {
            idForHttp = String(timeStamp)
            dataToPass["createdOn"] = timeStamp
            dataToPass["sld"] = String(timeStamp)
            httpMethod = .put
        } else {
            idForHttp = task?.sld ?? ""
            httpMethod = .patch
        }
        
        let newTask = Task(createdOn: self.dataToPass["createdOn"] as? Int,
                           description: self.dataToPass["description"] as? String,
                           sld: self.dataToPass["sld"] as? String,
                           progress: self.dataToPass["progress"] as? Int)
        
        mediator?.updateData(with: idForHttp, body: dataToPass, httpMethod: httpMethod, { result in
            switch result {
            
            case .success(_):

                self.delegate?.saveData(for: newTask, with: idForHttp)
                self.dismiss(animated: true) {
                }
                
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

        let text = textField.text
        dataToPass["description"] = text
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: descriptionTextField, queue: OperationQueue.main) { _ in
            
            let textCount = self.descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
            
            let textIsNotEmpty = textCount > 0
            
            self.saveButton.isEnabled = textIsNotEmpty
        }
        
        return true
    }
}
