//
//  TopicDetailsViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class TopicDetailsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var dueDateTexLabel: UILabel!
    
    // MARK: - Private properties
    var topicViewModel: TopicViewModel?
    lazy var mediator = TopicsMediator()
    var onCompletionFromDetailsVC: ((_ topicViewModel: TopicViewModel) -> ())?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    @IBAction func editNotesButtonPressed(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "Edit notes" {
            sender.setTitle("Save", for: .normal)
            notesTextView.isEditable = true
            notesTextView.becomeFirstResponder()
            
        } else {
            sender.setTitle("Edit notes", for: .normal)
            notesTextView.isEditable = false
            saveNotes()
        }
    }
    
    @IBAction func AddNewLinkButtonPressed(_ sender: UIButton) {
        showAddLinkAlertController()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditTopic", sender: nil)
    }
    
    // MARK: - Private methods
    private func setUpUI() {
        statusTextLabel.text = topicViewModel?.topic.status
        dueDateTexLabel.text = topicViewModel?.convertedDateToString()
        statusTextLabel.textColor = topicViewModel?.statusTextColor
        dueDateTexLabel.textColor = topicViewModel?.dueDateColor
        notesTextView.text = topicViewModel?.topic.notes
    }
    
    private func saveNotes() {
        
        let topic = Topic(id: topicViewModel?.topic.id,
                          title: topicViewModel?.topic.title,
                          links: topicViewModel?.topic.links, // ?
                          notes: notesTextView.text,
                          status: topicViewModel?.topic.status,
                          due_date: topicViewModel?.topic.due_date,
                          created_on: topicViewModel?.topic.created_on,
                          questions: topicViewModel?.topic.questions)
        
        // todo: freeze here
        
        mediator.updateData(for: topic) { [weak self] result in
            switch result {
            
            case .success(_):
                print("notes udated")
                
                self?.topicViewModel?.topic = topic
                
//                if let topicViewModel = self?.topicViewModel {
//                    self?.onCompletionFromDetailsVC?(topicViewModel)
//                }

            case .failure(let error):
                print(error)
                Alert.errorAlert(error: error)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        
        case "EditTopic":
            guard let vc = segue.destination as? TopicEditCreateViewController else { return }
            
            vc.title = "Edit Topic"
            vc.topicViewModel = topicViewModel

            vc.onCompletionFromEditVC = { [weak self] topicViewModel in
                
                self?.title = topicViewModel.topic.title
                self?.topicViewModel = topicViewModel
                
//                if let topicmc = self?.topicViewModel {
//                    self?.onCompletionFromDetailsVC?(topicmc)
//                }
            }
            
        case "ShowQuestions":
            print("Questions segue")
            
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("TopicDetailsViewController")
        if let topicViewModel = topicViewModel {
            onCompletionFromDetailsVC?(topicViewModel)
        }
    }
}
