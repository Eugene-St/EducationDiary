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
    @IBOutlet weak var completedSwitchLabel: UISwitch!
    
    var topic: Topic?
    private lazy var mediator = TopicsMediator()
    var onCompletionFromQuestionDetailsVC: ((_ topicViewModel: Question) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        createQuestion()
    }
    
    func createQuestion() {
        
        var questions: [Question] = []
        
        if let topicQuestions = topic?.questions {
            questions = topicQuestions
        }
        
        let timeStamp = Topic.generateTimeStamp()
        
        let  question = Question(id: String(timeStamp),
                                 topic_id: String(timeStamp),
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
        
        mediator.updateData(for: topic) { result in
            switch result {
            
            case .success(_):
                
                print("Success")
            // todo: on topicVC initialize success message
            
            case .failure(let error):
                Alert.errorAlert(error: error)
            }
        }
    }
}
