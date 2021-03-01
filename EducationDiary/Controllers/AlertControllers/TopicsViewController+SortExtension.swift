//
//  TopicsViewController+SortExtension.swift
//  EducationDiary
//
//  Created by Eugene St on 01.03.2021.
//

import UIKit

extension TopicsViewController {
    
    func showSortAlert() {
        let ac = UIAlertController(title: "Choose sort option", message: "", preferredStyle: .actionSheet)
        
        let createdDateAction = UIAlertAction(title: "Created date", style: .default) { [weak self] _ in
            self?.topicViewModels.sort(by: {$0.topic.created_on ?? 0 < $1.topic.created_on ?? 0})
            self?.tableView.reloadData()
        }
        
        let dueDateAction = UIAlertAction(title: "Due date", style: .default) { [weak self] _ in
            self?.topicViewModels.sort(by: {$0.topic.due_date ?? 0 < $1.topic.due_date ?? 0})
            self?.tableView.reloadData()
        }
        
        let statusAction = UIAlertAction(title: "Status", style: .default) { [weak self] _ in
            self?.topicViewModels.sort(by: {$0.topic.status ?? "" < $1.topic.status ?? ""})
            self?.tableView.reloadData()
        }
        
        let nameAction = UIAlertAction(title: "Name", style: .default) { [weak self] _ in
            self?.topicViewModels.sort(by: {$0.topic.title ?? "" < $1.topic.title ?? "" })
            self?.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        ac.addAction(createdDateAction)
        ac.addAction(dueDateAction)
        ac.addAction(statusAction)
        ac.addAction(nameAction)
        ac.addAction(cancelAction)
        
        present(ac, animated: true, completion: nil)
    }
    
}
