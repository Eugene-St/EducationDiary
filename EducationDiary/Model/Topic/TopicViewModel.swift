//
//  TopicViewModel.swift
//  EducationDiary
//
//  Created by Eugene St on 26.02.2021.
//

import UIKit

class TopicViewModel {
    var topic: Topic
    let key: String
    var statusTextColor: UIColor?
    var dueDateColor: UIColor?
    var statusButtonBackColor: UIColor?
    
    init(topic: Topic, key: String) {
        self.topic = topic
        self.key = key
    }
    
    func convertedDateToString() -> String {
        var dueDateStr = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        if let topicDueDate = topic.due_date {
            let dueDate = NSDate(timeIntervalSince1970: TimeInterval(topicDueDate)) as Date
            dueDateStr = "\(dateFormatter.string(from: dueDate))"
        }
        return dueDateStr
    }
    
    func convertedTimeStampToDate() -> Date {
        var pickerDate = Date()
        if let topicDueDate = topic.due_date {
            let date = NSDate(timeIntervalSince1970: TimeInterval(topicDueDate))
            pickerDate = date as Date
        }
        return pickerDate
    }
    
    func dueDateColorAndTextReturn() -> (color: UIColor, text: String) {
        let toDay = Date()
        var dueDateText = ""
        
        if let topicDueDate = topic.due_date {
            let dueDate = NSDate(timeIntervalSince1970: TimeInterval(topicDueDate)) as Date
            let calendar = NSCalendar.current
            let days = calendar.numberOfDaysBetween(toDay, and: dueDate)
            
            if days > 0 {
                dueDateColor = .black
                dueDateText = "Due in \(days) day(s)"
            } else if days == 0 {
                dueDateColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
                dueDateText = "Today"
            } else if days < 0 {
                dueDateColor = #colorLiteral(red: 0.6915014386, green: 0.06925391194, blue: 0.04372575395, alpha: 1)
                dueDateText = "\(abs(days)) day(s) overdue"
            }
        }
        
        return (dueDateColor ?? .purple, dueDateText)
    }
    
    func statusTextColorReturn() -> UIColor {
        switch topic.status {
        
        case TopicStatus.done.rawValue:
            statusTextColor = TopicStatus.done.associatedColor
            statusButtonBackColor = TopicStatus.done.associatedColor
            
        case TopicStatus.inProgress.rawValue:
            statusTextColor = TopicStatus.inProgress.associatedColor
            statusButtonBackColor = TopicStatus.inProgress.associatedColor
            
        case TopicStatus.onHold.rawValue:
            statusTextColor = TopicStatus.onHold.associatedColor
            statusButtonBackColor = TopicStatus.onHold.associatedColor
            
        case TopicStatus.unstarted.rawValue:
            statusTextColor = TopicStatus.unstarted.associatedColor
            statusButtonBackColor = TopicStatus.unstarted.associatedColor
            
        default: break
        }
        
        return statusTextColor ?? .purple
    }
}

