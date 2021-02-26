//
//  Topic.swift
//  EducationDiary
//
//  Created by Eugene St on 28.01.2021.
//

import UIKit

typealias Topics = [String : Topic]

struct Topic: Model {
    
    let id: String?
    let title: String?
    let links: [String]?
    let notes: String?
    let status: String?
    let due_date: Int?
    let created_on: Int?
    let questions: [Question]?
    
    var modelId: String {
        return id ?? ""
    }
    
    static func generateTimeStamp() -> Int {
        let timeStamp = Int(Date.timeIntervalSinceReferenceDate)
        return timeStamp
    }
}

class TopicViewModel {
    var topic: Topic
    let key: String
    var statusTextColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var dueDateColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    var statusButtonBackColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
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
    
    func dueDateColorReturn() -> UIColor {
        
        let toDay = Date()
        
        if let topicDueDate = topic.due_date {
            
            let dueDate = NSDate(timeIntervalSince1970: TimeInterval(topicDueDate)) as Date
            
            let calendar = NSCalendar.current
            let days = calendar.numberOfDaysBetween(toDay, and: dueDate)
            
            if days > 0 {
                dueDateColor = .black
            } else if days == 0 {
                dueDateColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            } else if days < 0 {
                dueDateColor = #colorLiteral(red: 0.6915014386, green: 0.06925391194, blue: 0.04372575395, alpha: 1)
            }
        }
        
        guard let dueDateColor = dueDateColor else { return .purple }
        
        return dueDateColor
    }
}
