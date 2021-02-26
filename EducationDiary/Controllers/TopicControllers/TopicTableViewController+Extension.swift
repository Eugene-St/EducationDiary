//
//  TopicTableViewController+Extension.swift
//  EducationDiary
//
//  Created by Eugene St on 26.02.2021.
//

import UIKit

extension TopicDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        topicViewModel?.topic.links?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath)
        
        cell.textLabel?.text = topicViewModel?.topic.links?[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {

            var links = topicViewModel?.topic.links
            
            links?.remove(at: indexPath.row)
            
            let topic = Topic(id: topicViewModel?.topic.id,
                              title: topicViewModel?.topic.title,
                              links: links,
                              notes: topicViewModel?.topic.notes,
                              status: topicViewModel?.topic.status,
                              due_date: topicViewModel?.topic.due_date,
                              created_on: topicViewModel?.topic.created_on,
                              questions: topicViewModel?.topic.questions)
            
            // todo: freeze here
            
            mediator.updateData(for: topic) { [weak self] result in
                switch result {
                
                case .success(_):
                    self?.topicViewModel?.topic = topic
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    
                case .failure(let error):
                    Alert.errorAlert(error: error)
                }
            }
            
        }
    }
}
