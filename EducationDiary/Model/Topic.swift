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
