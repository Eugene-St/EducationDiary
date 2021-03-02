//
//  QuestionDetailsViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class QuestionEditCreateViewController: UIViewController {
    
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var completedSwitchLabel: UISwitch!
    
    var topic: Topic?
    var changesMade: Bool = false
    private lazy var mediator = TopicsMediator()
    var onCompletionFromQuestionDetailsVC: ((_ topic: Topic) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        createQuestion()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        showCancelAlert()
    }
    
    @IBAction func switchButtonPressed(_ sender: UISwitch) {
        changesMade = true
    }
    
    private func createQuestion() {
        
        var questions: [Question] = []
        
        if let topicQuestions = topic?.questions {
            questions = topicQuestions
        }
        
        print("Questions before append - \(questions.count)")
        
        let timeStamp = Int(Date.timeIntervalSinceReferenceDate)
        
        let  question = Question(id: String(timeStamp),
                                 topic_id: String(timeStamp),
                                 text: questionTextView.text,
                                 answer: answerTextView.text,
                                 done: completedSwitchLabel.isOn)
        
        questions.insert(question, at: 0)
        
        print("Questions after append - \(questions.count)")
        
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
}

extension QuestionEditCreateViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        changesMade = true
    saveButton.isEnabled = !(questionTextView.text?.isEmpty ?? false)
    }
}