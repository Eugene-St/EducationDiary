//
//  TopicDetailsAlertController.swift
//  EducationDiary
//
//  Created by Eugene St on 26.02.2021.
//

import UIKit

extension TopicDetailsViewController {
    
    func showAddLinkAlertController(tableView: UITableView) {
        
        let placeholders = [
            "https://dataart.com",
            "http://google.com",
            "https://yandex.com"
        ]
        
        let ac = UIAlertController(title: "Add new link", message: nil, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            
            self?.saveLink(for: ac, tableView)
        }
        
        ac.addTextField { text in
            text.placeholder = placeholders.randomElement()
            text.autocapitalizationType = .none
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: text, queue: OperationQueue.main) { _ in
                
                let textCount = text.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                
                let textIsNotEmpty = textCount > 0
                
                saveAction.isEnabled = textIsNotEmpty
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        ac.addAction(cancelAction)
        saveAction.isEnabled = false
        ac.addAction(saveAction)
        present(ac, animated: true)
    }
    
    private func saveLink(for controller: UIAlertController, _ tableView: UITableView) {
        
        var links: [String] = []
        
        if let topicLinks = topicViewModel?.topic.links {
            links = topicLinks
        }
        
        links.insert(controller.textFields?.first?.text ?? "", at: 0)
        
        let topic = Topic(id: topicViewModel?.topic.id,
                          title: topicViewModel?.topic.title,
                          links: links,
                          notes: topicViewModel?.topic.notes,
                          status: topicViewModel?.topic.status,
                          due_date: topicViewModel?.topic.due_date,
                          created_on: topicViewModel?.topic.created_on,
                          questions: topicViewModel?.topic.questions)
        
        mediator.updateData(for: topic) { [weak self] result in
            
            switch result {
            case .success(_):
                self?.topicViewModel?.topic = topic
                tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                
            case .failure(let error):
                Alert.errorAlert(error: error)
            }
        }
    }
}
