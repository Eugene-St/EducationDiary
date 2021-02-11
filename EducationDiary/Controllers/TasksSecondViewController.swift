//
//  TasksSecondViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class TasksSecondViewController: UIViewController {
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var task: Task!
    private var mediator: TasksMediator?
    private var dataToPass: [String: Any] = [:]
    var delegate: TasksSecondViewControllerDelegate?
//    var completionHandler: (Task) -> Void?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediator = TasksMediator()
        descriptionTextField.placeholder = "description - required"
        descriptionTextField.autocapitalizationType = .sentences
        descriptionTextField.delegate = self
    }
    
    @IBAction func progressSliderPressed(_ sender: UISlider) {
        dataToPass["progress"] = sender.value as Float
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        var idForHttp: String
//        var httpMethod: HTTPMethods!
        let date = Date()
        let calendar = Calendar.current
        let createdOn = Float(calendar.component(.day, from: date))
        let timeStamp = String(format: "%.0f", Date.timeIntervalSinceReferenceDate)
        idForHttp = "\(timeStamp)"
        
//        var dataToPass: [String: String] = [:]
        dataToPass["created_on"] = createdOn as Float
//        dataToPass["description"] = descriptionTextField.text ?? "" as String
        dataToPass["id"] = idForHttp as String
        dataToPass["progress"] = 0.8 as Float
        
        
        
//        if task.id == nil {
//            let timeStamp = String(format: "%.0f", Date.timeIntervalSinceReferenceDate)
//            idForHttp = "\(timeStamp)"
//            httpMethod = .put
//        } else {
//            idForHttp = task.id!
//            httpMethod = .patch
//        }
        
        
        
//        let task = Task(created_on: createdOn, description: dataToPass["description"], id: idForHttp, progress: 0.5)
        
        
        mediator?.updateData(with: idForHttp, and: dataToPass, httpMethod: HTTPMethods.put, { result in
            switch result {
            
            case .success(_):
            print("Saved")
            
//            self?.bookmarks[idForHttp] = Bookmark(name: dataToPass["name"], text: dataToPass["text"])
//            self?.tableView.reloadData()
            
            
            
//                self.delegate?.saveData(for: task, with: idForHttp)
                
                
                DispatchQueue.global(qos: .background).async {
                    // todo: save to core data here
                }
                
            case .failure(let error):
//                self?.noNetworkAlert(error: error)
            print("error")
            }
        })
    }
}

extension TasksSecondViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let text = textField.text else { return }
        dataToPass["description"] = text
    }
}
