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
    let due_date: Int32?
    let created_on: Int32?
    let questions: [Question]?
    
    var modelId: String {
        return id ?? ""
    }
    
    static func generateTimeStamp() -> Int32 {
        let timeStamp = Int32(Date.timeIntervalSinceReferenceDate)
        return timeStamp
    }
}
