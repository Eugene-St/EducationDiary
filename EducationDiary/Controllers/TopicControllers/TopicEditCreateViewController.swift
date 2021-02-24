//
//  TopicEditCreateViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class TopicEditCreateViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var topicStatusButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Private properties
//    private var topicModel: TopicViewModel?
    private var topic: Topic?
    private lazy var mediator = TopicsMediator()
    var delegate: ModelViewControllerDelegate?
    
    // MARK: - Properties
    var status: String?
    var dueDate: Int?
    var topicTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadData()
//        let date = NSDate(timeIntervalSince1970: 1648464540)
//        datePicker.date = date as Date
        
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if topic == nil {
            createNewTopic()
        } else {
            updateTopic()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        showCancelAlert()
    }
    
    @IBAction func selectStatusButtonPressed(_ sender: UIButton) {
        showStatusAlertController()
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        showInfoAlert()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let myTimeStamp = Int(datePicker.date.timeIntervalSince1970)
        dueDate = myTimeStamp
        print(myTimeStamp)
    }
    
    
    private func createNewTopic() {
        
        let timeStamp = Topic.generateTimeStamp()
        
        let topic = Topic(id: String(timeStamp),
                          title: titleTextField.text,
                          links: nil,
                          notes: nil,
                          status: status,
                          due_date: dueDate,
                          created_on: timeStamp,
                          questions: nil)
        
        mediator.createNewData(for: topic) { [weak self] result in
            
            switch result {
            
            case .success(_):
                self?.delegate?.saveData(for: topic, with: topic.modelId)
                print("topic added")
                // todo: delegate topic back to TopicVC
                self?.navigationController?.popViewController(animated: true) // todo: dismiss
                // todo: on topicVC initialize success message
                
            case .failure(let error):
                print("Oops")
                Alert.errorAlert(error: error)
            }
        }
    }
    
    private func updateTopic() {
        
        let topic = Topic(id: self.topic?.id,
                          title: titleTextField.text,
                          links: self.topic?.links,
                          notes: self.topic?.notes,
                          status: status,
                          due_date: dueDate,
                          created_on: self.topic?.created_on,
                          questions: self.topic?.questions)
        
        mediator.updateData(for: topic) { result in
            
            switch result {
            
            case .success(_):
                // todo: delegate topic back to TopicVC
                self.navigationController?.popViewController(animated: true)
            // todo: on topicVC initialize success message
            
            case .failure(let error):
                print("Oops")
                Alert.errorAlert(error: error)
            }
        }
        
    }
    
    // setup UI
    private func setUpUI() {
        saveButton.isEnabled = false
        let color: UIColor = .black
        topicStatusButton.layer.cornerRadius = 5
        infoButton.layer.cornerRadius = 5
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.shadowColor = color.cgColor
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.shadowOffset = CGSize(width: 25, height: 25)
        backgroundView.layer.shadowOpacity = 0.3
    }
    
    // load data
    private func loadData() {
        
        if let topic = topic {
            titleTextField.text = topic.title
            topicStatusButton.setTitle(topic.status, for: .normal)
            status = topic.status // ?? могу вытягивать инфу из названия кнопки
            dueDate = topic.due_date
        } else {
            configureDefaultDate()
            configureDefaultStatus()
        }
    }
    
    // set default Date
    private func configureDefaultDate() {
        let defaultDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 7)
        dueDate = Int(defaultDate.timeIntervalSince1970)
        if let dueDate = dueDate {
        datePicker.date = NSDate(timeIntervalSince1970: TimeInterval(dueDate)) as Date
        }
    }
    
    // set default status
    private func configureDefaultStatus() {
        status = TopicStatus.unstarted.rawValue
        if let status = status {
            topicStatusButton.setTitle("Status: \(status)", for: .normal)
        }
    }
}

// MARK: - TextField Delegate
extension TopicEditCreateViewController: UITextFieldDelegate {
    
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
