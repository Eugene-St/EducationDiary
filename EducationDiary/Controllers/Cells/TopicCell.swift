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
        
        switch topicModel.topic.status {
        case TopicStatus.done.rawValue:
            topicModel.statusTextColor = TopicStatus.done.associatedColor
            topicModel.statusButtonBackColor = TopicStatus.done.associatedColor

        case TopicStatus.inProgress.rawValue:
            topicModel.statusTextColor = TopicStatus.inProgress.associatedColor
            topicModel.statusButtonBackColor = TopicStatus.inProgress.associatedColor

        case TopicStatus.onHold.rawValue:
            topicModel.statusTextColor = TopicStatus.onHold.associatedColor
            topicModel.statusButtonBackColor = TopicStatus.onHold.associatedColor

        default: break
        }

        statusTextLabel?.textColor = topicModel.statusTextColor
    }
    
    // configure due date label
    private func configureDueDate(for topicModel: TopicViewModel) {
        
        if topicModel.topic.status == TopicStatus.done.rawValue {
            dueDateTextLabel.isHidden = true
        } else {
            dueDateTextLabel.isHidden = false
        }
        
        let toDay = Date()
        
        guard let topicDueDate = topicModel.topic.due_date else { return }
        let dueDate = NSDate(timeIntervalSince1970: TimeInterval(topicDueDate)) as Date
        
        let calendar = NSCalendar.current
        let days = calendar.numberOfDaysBetween(toDay, and: dueDate)
        
        if days > 0 {
            dueDateTextLabel.text = "Due in \(days) day(s)"
        } else if days == 0 {
            dueDateTextLabel.text = "Today"
            topicModel.dueDateColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        } else if days < 0 {
            dueDateTextLabel.text = "\(abs(days)) days overdue"
            topicModel.dueDateColor = #colorLiteral(red: 0.6915014386, green: 0.06925391194, blue: 0.04372575395, alpha: 1)
        }
        
        dueDateTextLabel.textColor = topicModel.dueDateColor
    }
}
