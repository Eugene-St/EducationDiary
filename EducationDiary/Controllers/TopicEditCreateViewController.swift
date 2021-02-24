//
//  TopicEditCreateViewController.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

class TopicEditCreateViewController: UIViewController {
    
    @IBOutlet weak var topicStatusButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    
    private var topicModel: TopicViewModel?
    private lazy var mediator = TopicsMediator()
    
    var status: String?
    var dueDate: String?
    var topicTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        let timeStamp = Topic.generateTimeStamp()
        
        let topic = Topic(id: String(timeStamp),
                          title: "New topic",
                          links: ["https://swiftbook.ru"],
                          notes: nil,
                          status: status,
                          due_date: 0.0,
                          created_on: Float(timeStamp),
                          questions: nil)
        
        mediator.createNewData(for: topic) { result in
            switch result {
            
            case .success(_):
                print("topic added")
            case .failure(_):
                print("Oops")
            }
        }
        
        if topicModel == nil {
//            mediator.createNewData(for: Decodable & Encodable, <#T##completion: ResultClosure<URLResponse>##ResultClosure<URLResponse>##(Result<URLResponse, Error>) -> Void#>)
        } else {
//            mediator.updateData(for: Decodable & Encodable, <#T##completion: ResultClosure<URLResponse>##ResultClosure<URLResponse>##(Result<URLResponse, Error>) -> Void#>)
        }
        
    }
    
    
    
    @IBAction func selectStatusButtonPressed(_ sender: UIButton) {
        alertController()
    }
    
    
    
    private func setUpUI() {
        let color: UIColor = .black
        
        topicStatusButton.layer.cornerRadius = 5
        
        backgroundView.layer.cornerRadius = 20
        backgroundView.layer.shadowColor = color.cgColor
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.shadowOffset = CGSize(width: 25, height: 25)
        backgroundView.layer.shadowOpacity = 0.3
    }
}
