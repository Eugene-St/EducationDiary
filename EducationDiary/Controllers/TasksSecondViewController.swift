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
    
    // MARK: - Public Properties
    var task: Task!
    var delegate: TasksSecondViewControllerDelegate?
    
    // MARK: - Private Properties
    private var mediator: TasksMediator?
    private var dataToPass: [String: Any] = [:]
    
    // MARK: - View Didload
    override func viewDidLoad() {
        super.viewDidLoad()
        mediator = TasksMediator()
//        saveButton.isEnabled = false
    }
    
    // MARK: - IBActions
    @IBAction func progressSliderPressed(_ sender: UISlider) {
        dataToPass["progress"] = Int(sender.value)
        progressLabel.text = "\(Int(sender.value))%"
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {

        let idForHttp = String(Int(Date.timeIntervalSinceReferenceDate))
        dataToPass["createdOn"] = Int(Date.timeIntervalSinceReferenceDate)
        dataToPass["sld"] = String(Int(Date.timeIntervalSinceReferenceDate))

//        if task.id == nil {
//            let timeStamp = String(format: "%.0f", Date.timeIntervalSinceReferenceDate)
//            idForHttp = "\(timeStamp)"
//            httpMethod = .put
//        } else {
//            idForHttp = task.id!
//            httpMethod = .patch
//        }
        let newTask = Task(createdOn: self.dataToPass["createdOn"] as? Int,
                           description: self.dataToPass["description"] as? String,
                           sld: self.dataToPass["sld"] as? String,
                           progress: self.dataToPass["progress"] as? Int)
        
        mediator?.updateData(with: idForHttp, body: dataToPass, httpMethod: HTTPMethods.put, { result in
            switch result {
            
            case .success(_):
                
                self.delegate?.saveData(for: newTask, with: idForHttp)
                self.dismiss(animated: true, completion: nil)
                
                DispatchQueue.global(qos: .background).async {
                    // todo: save to core data here
                }
                
            case .failure(let error):
//                self?.noNetworkAlert(error: error)
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
        
        return true
    }
}
