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
    @IBOutlet weak var linksTableView: UITableView!
    @IBOutlet weak var questionsButton: UIButton!
    
    // MARK: - Private properties
    var topicViewModel: TopicViewModel?
    lazy var mediator = TopicsMediator()
    var onCompletionFromDetailsVC: ((_ topicViewModel: TopicViewModel) -> ())?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpUI()
    }
    
    // MARK: - IBActions
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
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        if let topicViewModel = topicViewModel {
            onCompletionFromDetailsVC?(topicViewModel)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddNewLinkButtonPressed(_ sender: UIButton) {
        showAddLinkAlertController(tableView: linksTableView)
        
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "EditTopic", sender: nil)
    }
    
    @IBAction func questionsButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowQuestions", sender: nil)
    }
    
    // MARK: - Private methods
    private func setUpUI() {
        statusTextLabel.text = topicViewModel?.topic.status
        dueDateTexLabel.text = topicViewModel?.convertedDateToString()
        statusTextLabel.textColor = topicViewModel?.statusTextColor
        dueDateTexLabel.textColor = topicViewModel?.dueDateColor
        notesTextView.text = topicViewModel?.topic.notes
        questionsButton.setTitle("Questions: \(topicViewModel?.topic.questions?.count ?? 0)", for: .normal)
    }
    
    private func saveNotes() {
        
        let topic = Topic(id: topicViewModel?.topic.id,
                          title: topicViewModel?.topic.title,
                          links: topicViewModel?.topic.links,
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
            }
            
            //todo: отступы
            
        case "ShowQuestions":
            print("Questions segue")
            
            guard let vc = segue.destination as? QuestionsViewController else { return }
            
            vc.title = "Questions/Answers" // todo: тайтл задавать в контроллере
            
            vc.topic = topicViewModel?.topic
            
            vc.onCompletionFromQuestionsVC = { [weak self] topic in
                if let topic = topic {
                    self?.topicViewModel?.topic = topic
                }
            }
            
        default:
            break
        }
    }
}



