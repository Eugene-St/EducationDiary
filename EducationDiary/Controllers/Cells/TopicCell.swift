//
//  TopicsCell.swift
//  EducationDiary
//
//  Created by Eugene St on 23.02.2021.
//

import UIKit

class TopicCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var statusTextLabel: UILabel!
    @IBOutlet weak var dueDateTextLabel: UILabel!

    func configureWith(topicModel: TopicViewModel) {
        titleTextLabel?.text = topicModel.topic.title
        configureStatus(for: topicModel)
        configureDueDate(for: topicModel)
    }
    
    // MARK: - Private Methods
    
    // configure status text label
    private func configureStatus(for topicModel: TopicViewModel) {
        statusTextLabel?.text = topicModel.topic.status
        statusTextLabel.textColor = topicModel.statusTextColorReturn()
    }
    
    // configure due date label
    private func configureDueDate(for topicModel: TopicViewModel) {
        
        if topicModel.topic.status == TopicStatus.done.rawValue {
            dueDateTextLabel.isHidden = true
        } else {
            dueDateTextLabel.isHidden = false
        }
        
        dueDateTextLabel.text = topicModel.dueDateColorAndTextReturn().text
        dueDateTextLabel.textColor = topicModel.dueDateColorAndTextReturn().color
    }
}
