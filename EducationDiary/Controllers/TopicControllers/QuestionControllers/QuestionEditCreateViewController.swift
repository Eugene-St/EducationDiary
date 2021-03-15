//
//  QuestionDetailsViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class QuestionEditCreateViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var completedSwitchLabel: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    var topic: Topic?
    var question: Question?
    var index: Int?
    var changesMade: Bool = false
    private lazy var mediator = TopicsMediator()
    var onCompletionFromQuestionDetailsVC: ((_ topic: Topic) -> ())?
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        saveButton.isEnabled = false
        registerForKeyboardNotifications()
    }
    
    // MARK: - IBActions
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if question == nil {
            createQuestion()
        } else {
            updateQuestion()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        showCancelAlert()
    }
    
    @IBAction func switchButtonPressed(_ sender: UISwitch) {
        saveButton.isEnabled = true
        changesMade = true
    }
    
    private func createQuestion() {
        var questions: [Question] = []
        if let topicQuestions = topic?.questions {
            questions = topicQuestions
        }
        
        let timeStamp = Int(Date.timeIntervalSinceReferenceDate)
        let  question = Question(id: String(timeStamp),
                                 topic_id: self.topic?.id,
                                 text: questionTextView.text,
                                 answer: answerTextView.text,
                                 done: completedSwitchLabel.isOn)
        
        questions.insert(question, at: 0)
        let topic = Topic(id: self.topic?.id,
                          title: self.topic?.title,
                          links: self.topic?.links,
                          notes: self.topic?.notes,
                          status: self.topic?.status,
                          due_date: self.topic?.due_date,
                          created_on: self.topic?.created_on,
                          questions: questions)
        
        mediator.updateData(for: topic) { [weak self] result in
            switch result {
            
            case .success(_):
                self?.onCompletionFromQuestionDetailsVC?(topic)
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                Alert.errorAlert(error: error)
            }
        }
    }
    
    private func updateQuestion() {
        var questions: [Question] = []
        if let topicQuestions = topic?.questions {
            questions = topicQuestions
        }
        
        let  question = Question(id: self.question?.id,
                                 topic_id: self.question?.topic_id,
                                 text: questionTextView.text,
                                 answer: answerTextView.text,
                                 done: completedSwitchLabel.isOn)
        
        questions[index ?? 0] = question
        
        let topic = Topic(id: self.topic?.id,
                          title: self.topic?.title,
                          links: self.topic?.links,
                          notes: self.topic?.notes,
                          status: self.topic?.status,
                          due_date: self.topic?.due_date,
                          created_on: self.topic?.created_on,
                          questions: questions)
        
        mediator.updateData(for: topic) { [weak self] result in
            switch result {
            
            case .success(_):
                self?.onCompletionFromQuestionDetailsVC?(topic)
                self?.navigationController?.popViewController(animated: true)
                
            case .failure(let error):
                Alert.errorAlert(error: error)
            }
        }
    }
    
    private func setupUI() {
        if question != nil {
            questionTextView.text = question?.text
            answerTextView.text = question?.answer
            
            if let progress = question?.done {
                completedSwitchLabel.isOn = progress
            }
        }
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @objc private func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
}

extension QuestionEditCreateViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        changesMade = true
        
        saveButton.isEnabled = !(questionTextView.text?.isEmpty ?? false)
    }
}
