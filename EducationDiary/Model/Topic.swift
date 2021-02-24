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
    
//    var defaultDate: Int? = {
//        var dueDate = 0
//        let defaultDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 7)
//        dueDate = Int(defaultDate.timeIntervalSince1970)
//        return dueDate
//    }()
    
    static func generateTimeStamp() -> Int {
        let timeStamp = Int(Date.timeIntervalSinceReferenceDate)
        return timeStamp
    }
}

class TopicViewModel {
    var topic: Topic
    let key: String
    var textColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    init(topic: Topic, key: String) {
        self.topic = topic
        self.key = key
    }
}
