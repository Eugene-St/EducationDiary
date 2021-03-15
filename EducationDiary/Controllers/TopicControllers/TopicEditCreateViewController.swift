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
    
    // MARK: - Properties
    var topicViewModel: TopicViewModel?
    private lazy var mediator = TopicsMediator()
    var onCompletionFromEditVC: ((_ topicModel: TopicViewModel) -> ())?
    var changesMade: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        loadData()
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if topicViewModel == nil {
            createNewTopic()
        } else {
            updateTopic()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        showCancelAlert()
    }
    
    @IBAction func selectStatusButtonPressed(_ sender: UIButton) {
        changesMade = true
        
        if topicViewModel != nil {
            saveButton.isEnabled = true
        }
        
        showStatusAlertController()
    }
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        showInfoAlert()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        changesMade = true
        if topicViewModel != nil {
            saveButton.isEnabled = true
        }
    }
    
    private func createNewTopic() {
        let timeStamp = Topic.generateTimeStamp()
        let topic = Topic(id: String(timeStamp),
                          title: titleTextField.text,
                          links: nil,
                          notes: nil,
                          status: topicStatusButton.titleLabel?.text,
                          due_date: Int32(datePicker.date.timeIntervalSince1970),
                          created_on: timeStamp,
                          questions: nil)
        
        mediator.createNewData(for: topic) { [weak self] result in
            switch result {
            
            case .success(_):
                let topicViewModel = TopicViewModel(topic: topic, key: topic.modelId)
                topicViewModel.statusTextColor = self?.topicStatusButton.backgroundColor
                topicViewModel.statusButtonBackColor = self?.topicStatusButton.backgroundColor
                self?.onCompletionFromEditVC?(topicViewModel)
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                Alert.errorAlert(error: error)
            }
        }
    }
    
    private func updateTopic() {
        let topic = Topic(id: self.topicViewModel?.topic.id,
                          title: titleTextField.text,
                          links: self.topicViewModel?.topic.links,
                          notes: self.topicViewModel?.topic.notes,
                          status: topicStatusButton.titleLabel?.text,
                          due_date: Int32(datePicker.date.timeIntervalSince1970),
                          created_on: self.topicViewModel?.topic.created_on,
                          questions: self.topicViewModel?.topic.questions)
        
        mediator.updateData(for: topic) { [weak self] result in
            switch result {
            
            case .success(_):
                self?.topicViewModel?.topic = topic
                self?.topicViewModel?.statusTextColor = self?.topicStatusButton.backgroundColor
                self?.topicViewModel?.statusButtonBackColor = self?.topicStatusButton.backgroundColor
                self?.topicViewModel?.dueDateColor = self?.topicViewModel?.dueDateColorAndTextReturn().color
                if let topicViewModel = self?.topicViewModel {
                    self?.onCompletionFromEditVC?(topicViewModel)
                }
                
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                Alert.errorAlert(error: error)
            }
        }
    }
    
    // setup UI
    private func setUpUI() {
        saveButton.isEnabled = false
        topicStatusButton.layer.cornerRadius = 5
        infoButton.layer.cornerRadius = 5
        backgroundView.layer.cornerRadius = 10
        topicStatusButton.backgroundColor = .black
        
        if let topicModel = topicViewModel {
            topicStatusButton.backgroundColor = topicModel.statusButtonBackColor
        }
    }
    
    // load data
    private func loadData() {
        if let topicModel = topicViewModel {
            titleTextField.text = topicModel.topic.title
            topicStatusButton.setTitle(topicModel.topic.status, for: .normal)
            datePicker.date = topicModel.convertedTimeStampToDate()
            
        } else {
            configureDefaultDate()
            configureDefaultStatus()
        }
    }
    
    // set default Date
    private func configureDefaultDate() {
        let defaultDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 7)
        datePicker.date = defaultDate
    }
    
    // set default status
    private func configureDefaultStatus() {
        topicStatusButton.setTitle(TopicStatus.unstarted.rawValue, for: .normal)
    }
}

// MARK: - TextField Delegate
extension TopicEditCreateViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range,
                                                                     with: string)
        changesMade = true
        
        if !text.isEmpty {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        return true
    }
    
    // return key validates input and saves changes
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if topicViewModel == nil {
            createNewTopic()
        } else {
            updateTopic()
        }
        return true
    }
}
